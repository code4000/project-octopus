### Create database

Run `rails db:create db:migrate`

### Set up master admin account
Run `User.create(email: "you@yours.com", password: "yourpassword", role: "master")`
