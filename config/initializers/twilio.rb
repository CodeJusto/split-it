
account_sid = ENV['TWILIO_ID']
auth_token = ENV['TWILIO_SECRET']
$twilio = Twilio::REST::Client.new account_sid, auth_token

from = ENV['COMPANY_PHONE']# Your Twilio number
