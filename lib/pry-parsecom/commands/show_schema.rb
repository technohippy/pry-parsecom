# encoding: UTF-8

PryParsecom::Commands.create_command "show-schema" do
  group 'Parse.com'
  description 'Show a parse class schema'

  def options opt
    opt.banner unindent <<-EOS
      Usage: show-schema [class name]

      Show a parse class schema
    EOS
  end

  def process
    unless args.size == 1
      output.puts opt
      return
    end

    PryParsecom::Setting.setup_if_needed
    setting = PryParsecom::Setting.current_setting
    unless setting
      output.puts 'Now using no app'
      return
    end

    class_name = args.first.to_s
    schema = setting.schema class_name
    table = PryParsecom::Table.new %w(Name Type)
    schema.to_a.sort{|a1, a2| a1[0] <=> a2[0]}.each do |name, type|
      if type =~ /^\*(.*)/
        type = "pointer<#{$1}>"
      end
      table.add_row [name, type]
    end
    output.puts table
  end
end
