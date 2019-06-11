namespace :add do
  # Give a description for the task
  desc "Add OTP to all users"
  # Define the task
  task otp: :environment do
    User.find_each { |user| user.update_attribute(:otp_secret_key, User.otp_random_secret) }
  end
end
