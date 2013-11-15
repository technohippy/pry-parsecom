require 'pry'
require 'pry-parsecom/version'

unless ENV['DISABLE_PRY_PARSECOM']
  require 'io/console'
  require 'parsecom'
  require 'mechanize'
  require 'json'
  require 'yaml'
  require 'pry-parsecom/setting'
  require 'pry-parsecom/commands'
#  require 'pry-parsecom/model_formatter'
  
  module PryParsecom
    module_function

    def ask_email_and_password
      print 'Input parse.com email: '
      email = gets
      print 'Input parse.com password: '
      password = STDIN.noecho(&:gets)
      puts
      [email.strip, password.strip]
    end
  end
end
