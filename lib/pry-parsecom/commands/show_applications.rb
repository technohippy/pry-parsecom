# encoding: UTF-8

PryParsecom::Commands.create_command "show-applications" do
  group 'Parse.com'
  description 'Show all parse applications'

  def options opt
    opt.banner unindent <<-EOS
      Usage: show-applications

      Show all parse applications
    EOS
  end

  def process
    PryParsecom::Setting.setup_if_needed
    PryParsecom::Setting.app_names.each do |app|
      output.puts app
    end
  end
end