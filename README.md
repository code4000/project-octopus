### Create database

Run `rails db:create db:migrate`

### Set up master admin account
In Rails console run `User.create(email: "you@yours.com", password: "yourpassword", role: "master")`
