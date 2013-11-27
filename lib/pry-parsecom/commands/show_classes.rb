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
      output.puts opts
      return
    end

    PryParsecom::Setting.setup_if_needed
    app_name = args.first || PryParsecom::Setting.current_app
    setting = PryParsecom::Setting.by_name app_name
    unless setting
      output.puts "Application no found: #{app_name}"
      return
    end

    table = PryParsecom::Table.new %w(Name Class)
    setting.classes.each do |parse_class|
      class_name = parse_class.sub /^_/, 'Parse::'
      table.add_row [parse_class, class_name]
    end
    output.puts table
    output.puts "(cached at: #{PryParsecom::Setting.cache_time})"
  end
end
