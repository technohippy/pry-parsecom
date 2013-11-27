# pry-parsecom

pry-parsecom is a REPL for parse.com based on pry. It allows you to manage your parse.com applications through CLI.

## Usage

### Login/Logout

First of all, you should log in parse.com. Once you log in, your account, credentials and schemas are stored in ~/.pry-console directory.

    $ pry-parsecom
    [1] pry(main)> login-parse
    Email for parse.com: andyjpn@gmail.com
    Password for parse.com: 
    logged in
    [2] pry(main)> logout-parse
    logged out

### Show your applications' information

There are three main show-something commands to see your applications' information. 

- show-application command lists all names of your parse applications. 
- show-classes command lists all classes defined in the using parse application. 
- show-schemas command shows schemas for the given parse class.

Note that classes and schemas are cached when you call login-parse command. To update them you need to calling the command again.

### Choose an application

Before accessing your parse.com application, you have to declare which application you would like to use by calling the use-application command. 

    [1] pry(main)> use-application YourApp
    The current app is YourApp.

### Use parse objects

Once you choose an application, parsecom Objects for the application are automatically defined. You can use these objects to manage your parse.com application.

    [1] pry(main)> use-application YourApp
    The current app is YourApp.
    [2] pry(main)> post = Post.find(:where => {:body => 'Hello'}).first
    => [---
    __type: Post
    author:
      __type: Pointer
      className: _User
      objectId: ZybBXQEIjI
    body: Hello
    comments: <Ralations>
    ...snip...
    [3] pry(main)> post.body = 'World!'
    => "World!"
    [4] pry(main)> post.save!
    => true

To know more detail about the parsecom library, see http://github.com/technohippy/parsecom

### Examples

    $ pry-parsecom
    [1] pry(main)> help parse.com
    Parse.com
      login-parsecom     Log in parse.com
      logout-parsecom    Log out parse.com
      show-applications  Show all parse applications
      show-classes       Show all parse classes
      show-credentials   Show credentials for parse.com
      show-schema        Show a parse class schema
      use-application    Set the current parse.com application
    [2] pry(main)> show-applications
    Email for parse.com: andyjpn@gmail.com
    Password for parse.com: 
        Name   | Using
      ================
      FakeApp  |
      FakeApp2 |
    (cached at: 2013-11-18 13:59:48 +0900)
    [3] pry(main)> use-application FakeApp
    The current app is FakeApp.
    [4] pry(main)> show-applications
        Name   | Using
      ================
      FakeApp  | *
      FakeApp2 |
    (cached at: 2013-11-18 13:59:48 +0900)
    [5] pry(main)> show-credentials
           Key       |                  Value
      =========================================================
      APPLICATION_ID | abcdefghijklmnopqrstuvwxyzabcdefghijklmn
      REST_API_KEY   | abcdefghijklmnopqrstuvwxyzabcdefghijklmn
      MASTER_KEY     | abcdefghij******************************
    (cached at: 2013-11-18 13:59:48 +0900)
    [6] pry(main)> show-classes
       Name   |    Class   
      =====================
      Comment | Comment    
      Post    | Post       
      _User   | Parse::User
    (cached at: 2013-11-18 13:59:48 +0900)
    [7] pry(main)> show-schema Post
        Name   |       Type
      ============================
      author   | pointer<_User>
      body     | string
      comments | relation<Comment>
    (cached at: 2013-11-18 13:59:48 +0900)
    [8] pry(main)> Post.find :all
    => [---
    __type: Post
    author:
      __type: Pointer
      className: _User
      objectId: ZybBXQEIjI
    body: Hello
    comments: <Ralations>
    ...snip...
    [9] pry(main)> logout
    logged out
    [10] pry(main)> exit

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
