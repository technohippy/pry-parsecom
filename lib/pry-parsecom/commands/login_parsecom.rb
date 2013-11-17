# encoding: UTF-8

PryParsecom::Commands.create_command "login-parsecom" do
  group 'Parse.com'
  description 'Log in parse.com'

  def options opt
    opt.banner <<-EOS.gsub(/^\s+/, '')
      Usage: login-parsecom

      Log in parse.com
    EOS
  end

  def process
    PryParsecom::Setting.login *PryParsecom.ask_email_and_password
    output.puts 'logged in'
  end
end
