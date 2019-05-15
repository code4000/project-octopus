class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    raw, enc = Devise.token_generator.generate(User, :reset_password_token)
    @token = raw
    @user.reset_password_token = enc
    @user.reset_password_sent_at = Time.now.utc
    @user.save(validate: false)
    mail(to: @user.email, subject: 'Welcome to Octopus')
  end
end
