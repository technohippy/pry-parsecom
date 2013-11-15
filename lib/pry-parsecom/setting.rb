module PryParsecom
  class Setting
    DOT_DIRNAME = "#{Dir.home}/.pry-parsecom"
    SETTINGS_FILENAME = "settings"
    IGNORES_FILENAME = "ignores"
    KEYS_FILENAME = "keys"
    SCHEMAS_FILENAME = "schemas"

    USER_AGENT = 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)'
    LOGIN_URL = 'https://parse.com/apps'
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
      end

      def current_setting
        @@apps[@@current_app]
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

      def load
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
              app_id = key['app_id']
              api_key = key['api_key']
              master_key = key['master_key']
              schema = schemas[app_name]
              @@apps[app_name] = Setting.new app_name, app_id, api_key, master_key, schema
            end
            return true
          end
        end
        false
      end

      def save
        keys = {}
        schemas = {}
        @@apps.each do |app_name, setting|
          keys[app_name] = {
            'app_id' => setting.app_id,
            'api_key' => setting.api_key,
            'master_key' => setting.master_key
          }

          schemas[app_name] = setting.schema
        end
        write_setting_file KEYS_FILENAME, keys
        write_setting_file SCHEMAS_FILENAME, schemas
      end

      def refresh email, password
        login_page = @@agent.get LOGIN_URL
        apps_page = login_page.form_with :id => 'new_user_session' do |form|
          form['user_session[email]'] = email
          form['user_session[password]'] = password
        end.submit

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

        save
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
    end

    attr_accessor :app_name, :app_id, :api_key, :master_key, :schema

    def initialize app_name, app_id, api_key, master_key, schema
      @app_name, @app_id, @api_key, @master_key, @schema = 
        app_name, app_id, api_key, master_key, schema
    end

    def set parse_client
      Parse.credentials :application_id => @app_id, :api_key => @api_key, :mater_key => @master_key
      parse_client.application_id = @app_id
      parse_client.api_key = @api_key
      parse_client.master_key = @master_key
      parse_client

      schema['collection'].each do |e|
        class_name = e['id']
        next if class_name[0] == '_'

        if Object.const_defined? class_name
          puts "#{class_name.to_s} has already exist."
          next
        end
        Parse::Object class_name
      end
    end

    def reset parse_client
      schema['collection'].each do |e|
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
      parse_client.application_id = nil
      parse_client.api_key = nil
      parse_client.master_key = nil
      parse_client
    end

    def classes
      schema['collection'].map{|e| e['id']}.sort
    end
  end
end
