require 'pry'
require 'pry-parsecom/version'

if ENV['ENABLE_PRY_PARSECOM']
  require 'io/console'
  require 'parsecom'
  require 'mechanize'
  require 'json'
  require 'yaml'
  require 'pry-parsecom/setting'
  require 'pry-parsecom/commands'
  require 'pry-parsecom/table'
  require 'pry-parsecom/model_formatter'
  
  module PryParsecom
    module_function

    def ask_email_and_password
      print 'Email for parse.com: '
      email = gets
      print 'Password for parse.com: '
      password = STDIN.noecho(&:gets)
      puts
      [email.strip, password.strip]
    end
  end
end
