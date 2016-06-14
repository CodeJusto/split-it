class Notifications < ApplicationMailer
 default from: 'ceebs@ceebs.faith'
 
  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to Split-it! Site')
  end

  def update_contributor(user, payee, payment)
    @user = user.first
    @payee = payee.first.name
    @payment = payment
    mail(to: @user.email, subject: 'Someone has contributed to your cart!')
  end

  def delete_contributor(user, cart)
    @user = user
    @cart = cart
    mail(to: @user.email, subject: 'You have been removed from a cart')
  end

  def invite_contributor(inviter, cart, email)
    @inviter = inviter
    @cart = cart
    @email = email
    mail(to: @email, subject: 'You have been invited to a cart')
  end

end
