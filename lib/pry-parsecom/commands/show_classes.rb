# encoding: UTF-8

PryParsecom::Commands.create_command 'show-classes' do
  group 'Parse.com'
  description 'Show all parse classes'

  def options opt
    opt.banner unindent <<-EOS
      Usage: show-classes [app_name]

      Show all parse classes
    EOS
  end

  def process
    if 1 < args.size
      output.puts opt
      return
    end

    PryParsecom::Setting.setup_if_needed
    setting = PryParsecom::Setting.current_setting
    unless setting
      output.puts 'Now using no app'
      return
    end

    table = PryParsecom::Table.new %w(Name)
    setting.classes.each do |klass|
      table.add_row klass
    end
    output.puts table
  end
end
