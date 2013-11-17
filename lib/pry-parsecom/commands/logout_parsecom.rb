# encoding: UTF-8

PryParsecom::Commands.create_command "logout-parsecom" do
  group 'Parse.com'
  description 'Log out parse.com'

  def options opt
    opt.banner <<-EOS.gsub(/^\s+/, '')
      Usage: logout-parsecom

      Log in parse.com
    EOS
  end

  def process
    PryParsecom::Setting.logout
    output.puts 'logged out'
  end
end
