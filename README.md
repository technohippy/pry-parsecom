# pry-parsecom

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'pry-parsecom'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pry-parsecom

## Usage

    $ pry-parsecom
    [1] pry(main)> show-applications
    Input parse.com email: andyjpn@gmail.com
    Input parse.com password: 
      Name
    ========
    FakeApp
    FakeApp2
    [2] pry(main)> use FakeApp
    The current app is FakeApp.
    [3] pry(main)> show-credentials
         Key       |                  Value
    =========================================================
    APPLICATION_ID | abcdefghijklmnopqrstuvwxyzabcdefghijklmn
    REST_API_KEY   | abcdefghijklmnopqrstuvwxyzabcdefghijklmn
    MASTER_KEY     | abcdefghij******************************
    [4] pry(main)> show-classes
    Comment
    Post
    _User
    [5] pry(main)> Comment.find :all
    => [<Comment: {"author"=>#<Parse::Pointer:0x007fc6796dbba8 @r...
    [6] pry(main)> exit

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
