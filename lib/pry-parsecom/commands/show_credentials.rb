# encoding: UTF-8

PryParsecom::Commands.create_command "show-credentials" do
  group 'Parse.com'
  description 'Show credentials for parse.com'

  def options opt
    opt.banner unindent <<-EOS
      Usage: show-credentials

      Show parse.com credentials: application_id, rest_api_key and master_key.
    EOS
  end

  def process
    if 1 < args.size
      output.puts opts
      return
    end

    PryParsecom::Setting.setup_if_needed
    table = PryParsecom::Table.new %w(Key Value)
    if args.empty?
      table.add_row ['APPLICATION_ID', Parse.application_id || '']
      table.add_row ['REST_API_KEY', Parse.api_key || '']
      table.add_row ['MASTER_KEY', (Parse.master_key || '').sub(/.{30}$/, '*' * 30)]
    else
      app_name = args.first
      setting = PryParsecom::Setting.by_name app_name
      table.add_row ['APPLICATION_ID', setting.app_id]
      table.add_row ['REST_API_KEY', setting.api_key]
      table.add_row ['MASTER_KEY', (setting.master_key || '').sub(/.{30}$/, '*' * 30)]
    end
    output.puts table
    output.puts "(cached at: #{PryParsecom::Setting.cache_time})"
  end
end
