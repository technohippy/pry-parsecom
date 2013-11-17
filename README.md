# pry-parsecom

CLI for parse.com

## Usage

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
    Input parse.com email: andyjpn@gmail.com
    Input parse.com password: 
      Name   | Selected
    ===================
    FakeApp  |
    FakeApp2 |
    [3] pry(main)> use-application FakeApp
    The current app is FakeApp.
    [4] pry(main)> show-applications
      Name   | Selected
    ===================
    FakeApp  | *
    FakeApp2 |
    [5] pry(main)> show-credentials
         Key       |                  Value
    =========================================================
    APPLICATION_ID | abcdefghijklmnopqrstuvwxyzabcdefghijklmn
    REST_API_KEY   | abcdefghijklmnopqrstuvwxyzabcdefghijklmn
    MASTER_KEY     | abcdefghij******************************
    [6] pry(main)> show-classes
     Name  
    =======
    Comment
    Post   
    _User  
    [7] pry(main)> show-schema Post
      Name   |       Type
    ============================
    author   | pointer<_User>
    body     | string
    comments | relation<Comment>
    [8] pry(main)> Post.find :all
    => [---
    __type: Post
    author:
      __type: Pointer
      className: _User
      objectId: ZybBXQEIjI
    body: Hello
    comments: <Ralations>
    createdAt: '2013-11-17T13:37:44.055Z'
    updatedAt: '2013-11-17T13:38:30.908Z'
    objectId: lNKMPYSCTw
    ,
     ---
    __type: Post
    author:
      __type: Pointer
      className: _User
      objectId: ZybBXQEIjI
    body: World
    comments: <Ralations>
    createdAt: '2013-11-17T14:33:00.134Z'
    updatedAt: '2013-11-17T14:33:25.436Z'
    objectId: ur2StDqAFD
    ]
    [9] pry(main)> logout
    logged out
    [10] pry(main)> show-applications
      Name   | Selected
    ===================
    [11] pry(main)> exit

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
