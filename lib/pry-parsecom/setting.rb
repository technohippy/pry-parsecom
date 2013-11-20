module PryParsecom
  class Setting
    DOT_DIRNAME = "#{Dir.home}/.pry-parsecom"
    SETTINGS_FILENAME = "settings"
    IGNORES_FILENAME = "ignores"
    KEYS_FILENAME = "keys"
    SCHEMAS_FILENAME = "schemas"

    USER_AGENT = 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)'
    LOGIN_URL = 'https://parse.com/apps'
    LOGIN_SUCCESS_FILENAME= 'apps.html'
    LOGIN_ERROR_FILENAME = 'user_session.html'
    APPS_XPATH = '/html/body/div[4]/div[2]/div/div/div/div[3]/ul/li/ul/li/a'
    APP_NAME_XPATH = '//*[@id="parse_app_name"]'
    APP_KEYS_CSS = 'div.app_keys.window'
    APP_ID_XPATH = 'div[2]/div[1]/div[2]/div/input'
    API_KEY_XPATH = 'div[2]/div[5]/div[2]/div/input'
    MASTER_KEY_XPATH = 'div[2]/div[6]/div[2]/div/input'

    @@agent = Mechanize.new
    @@agent.user_agent = USER_AGENT
    @@current_app = nil
    @@apps = {}

    class <<self
      def current_app
        @@current_app
      end

      def current_app= app
        @@current_app = app
        store_setting
        app
      end

      def current_setting
        @@apps[@@current_app]
      end

      def setup_if_needed
        if @@apps.empty?
          unless restore
            login *PryParsecom.ask_email_and_password 
          end
        end
      end

      def read_setting_file name
        begin File.read "#{DOT_DIRNAME}/#{name}" rescue '' end
      end

      def write_setting_file name, hash
        Dir.mkdir DOT_DIRNAME unless File.exist? DOT_DIRNAME
        File.open "#{DOT_DIRNAME}/#{name}", 'w' do |file|
          file.write YAML.dump(hash)
        end
      end

      def restore
        if File.exist? DOT_DIRNAME
          settings = read_setting_file SETTINGS_FILENAME
          ignores = read_setting_file IGNORES_FILENAME
          keys = read_setting_file KEYS_FILENAME
          schemas = read_setting_file SCHEMAS_FILENAME

          if !keys.empty? && !schemas.empty?
            ignores = ignores.split "\n"
            keys = YAML.load keys
            schemas = YAML.load schemas
            keys.each do |app_name, key|
              @@apps[app_name] = Setting.new app_name, key['app_id'], key['api_key'], 
                key['master_key'], schemas[app_name]
            end
            unless settings.empty?
              settings = YAML.load settings
              @@current_app = settings['current_app']
            end
            return true
          end
        end
        false
      end

      def store_cache
        keys = {}
        schemas = {}
        @@apps.each do |app_name, setting|
          keys[app_name] = {
            'app_id' => setting.app_id,
            'api_key' => setting.api_key,
            'master_key' => setting.master_key
          }

          schemas[app_name] = setting.schemas
        end
        write_setting_file KEYS_FILENAME, keys
        write_setting_file SCHEMAS_FILENAME, schemas
      end

      def store_setting
        if @@current_app
          write_setting_file SETTINGS_FILENAME, 'current_app' => @@current_app
        end
      end

      def login email, password
        @@apps = {}

        login_page = @@agent.get LOGIN_URL
        apps_page = login_page.form_with :id => 'new_user_session' do |form|
          form['user_session[email]'] = email
          form['user_session[password]'] = password
        end.submit

        if apps_page.filename == LOGIN_ERROR_FILENAME
          puts 'login error'
          return
        end

        apps_page.search(APPS_XPATH).each do |a|
          href = a.attributes['href'].to_s
          count_page = @@agent.get "#{href}/collections/count"
          schema = JSON.parse count_page.content
          edit_page = @@agent.get "#{href}/edit"
          app_name = edit_page.search(APP_NAME_XPATH).first.attributes['value'].to_s
          app_keys = edit_page.search('div.app_keys.window')
          app_id = app_keys.search(APP_ID_XPATH).first.attributes['value'].to_s
          api_key = app_keys.search(API_KEY_XPATH).first.attributes['value'].to_s
          master_key = app_keys.search(MASTER_KEY_XPATH).first.attributes['value'].to_s

          next if read_setting_file(IGNORES_FILENAME).split("\n").include? app_name

          @@apps[app_name] = Setting.new app_name, app_id, api_key, master_key, schema
        end

        store_cache
      end

      def logout
        FileUtils.rm "#{DOT_DIRNAME}/#{KEYS_FILENAME}"
        FileUtils.rm "#{DOT_DIRNAME}/#{SCHEMAS_FILENAME}"
        @@apps.clear
        @@current_app = nil
      end

      def cache_time
        if File.exist? DOT_DIRNAME
          File.mtime "#{DOT_DIRNAME}/#{SCHEMAS_FILENAME}"
        else
          nil
        end
      end

      def app_names
        @@apps.keys
      end

      def has_app? app_name
        @@apps.has_key? app_name.to_s
      end

      def by_name app_name
        @@apps[app_name.to_s]
      end
      alias [] by_name

      def each &block
        @@apps.each &block
      end
    end

    attr_accessor :app_name, :app_id, :api_key, :master_key, :schemas

    def initialize app_name, app_id, api_key, master_key, schemas
      @app_name, @app_id, @api_key, @master_key, @schemas = 
        app_name, app_id, api_key, master_key, schemas
    end

    def set
      Parse.credentials :application_id => @app_id, :api_key => @api_key, :master_key => @master_key
      Parse::Client.default.application_id = @app_id
      Parse::Client.default.api_key = @api_key
      Parse::Client.default.master_key = @master_key

      schemas['collection'].each do |e|
        class_name = e['id']
        next if class_name[0] == '_'

        if Object.const_defined? class_name
          puts "#{class_name.to_s} has already exist."
          next
        end
        Parse::Object class_name
      end
    end

    def reset
      schemas['collection'].each do |e|
        class_name = e['id']
        next if class_name[0] == '_'

        if Object.const_defined? class_name
          klass = Object.const_get class_name
          if klass < Parse::Object
            Object.class_eval do
              remove_const class_name
            end
          end
        end
      end

      Parse.credentials :application_id => '', :api_key => '', :mater_key => ''
      Parse::Client.default.application_id = nil
      Parse::Client.default.api_key = nil
      Parse::Client.default.master_key = nil
      Parse::Client.default
    end

    def classes
      schemas['collection'].map{|e| e['id']}.sort
    end

    def schema class_name
      schms = schemas['collection'].select do |e| 
        e['id'] == class_name || e['display_name'] == class_name
      end
      schms.empty? ? [] : schms.first['schema']
    end
  end
end
