# encoding: UTF-8

PryParsecom::Commands.create_command "use" do
  group 'Parse.com'
  description 'Set the current parse.com application'

  def options opt
    opt.banner <<-EOS.gsub(/^\s+/, '')
      Usage: use your-app-name

      Set the current parse.com application
    EOS
  end

  def process
    PryParsecom::Setting.setup_if_needed
    unless args.size == 1
      output.puts opt
      return
    end
    app_name = args.first.to_s
    unless PryParsecom::Setting.has_app? app_name
      output.puts "#{app_name} does not exist."
      return
    end

    unless PryParsecom::Setting.current_app.to_s.empty?
      prev_setting = PryParsecom::Setting.current_setting
      prev_setting.reset if prev_setting
    end

    setting = PryParsecom::Setting[app_name]
    setting.set
    PryParsecom::Setting.current_app = app_name
    output.puts "The current app is #{app_name}."
  end
end
