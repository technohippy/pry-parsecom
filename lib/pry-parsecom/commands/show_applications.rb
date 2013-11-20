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
    table = PryParsecom::Table.new %w(Name Using)
    PryParsecom::Setting.app_names.each do |name|
      table.add_row [name, name == PryParsecom::Setting.current_app ? '*' : '']
    end
    output.puts table
    output.puts "(cached at: #{PryParsecom::Setting.cache_time})"
  end
end
