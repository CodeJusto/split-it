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

  def cart_deleted(contributor, cart)
    @contributor = contributor
    @cart = cart
    mail(to: @contributor.email, subject: 'Your cart has been deleted')
  end

  def send_invoice(contributor, payment, cart)
    @contributor = contributor.first
    @cart = cart
    @payment = payment
    mail(to: @contributor.email, subject: "You have made a contribution to #{ @cart.name }")
  end

  def cart_complete(organizer, contributor, cart)
    @organizer = organizer
    @cart = cart
    @contributor = contributor
    mail(to: @contributor.email, subject: "#{@cart.name} has successfully reached its goal!")
  end

  def cart_failure(organizer, contributor, cart)
    @organizer = organizer
    @cart = cart
    @contributor = contributor
    mail(to: @contributor.email, subject: "Sorry #{@contributor.name}, #{@cart.name} couldnt meet its goal in time.")
  end

end
