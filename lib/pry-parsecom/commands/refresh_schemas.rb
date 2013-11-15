# encoding: UTF-8

PryParsecom::Commands.create_command "refresh-schemas" do
  group 'Parse.com'
  description 'Refresh parse.com schemas'

  def options opt
    opt.banner <<-EOS.gsub(/^\s+/, '')
      Usage: refresh-schemas

      Refresh parse.com schemas
    EOS
  end

  def process
    PryParsecom::Setting.refresh *PryParsecom.ask_email_and_password
    puts PryParsecom::Setting.app_names
  end
end
