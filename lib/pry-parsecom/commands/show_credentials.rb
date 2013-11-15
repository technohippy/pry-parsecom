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
    PryParsecom::Setting.setup_if_needed
    table = PryParsecom::Table.new %w(Key Value), [
      ['APPLICATION_ID', Parse.application_id],
      ['REST_API_KEY', Parse.api_key],
      ['MASTER_KEY', (Parse.master_key || '').sub(/.{30}$/, '*' * 30)]
    ]
    output.puts table
  end
end
