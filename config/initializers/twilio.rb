
account_sid = ENV['TWILIO_ID']
auth_token = ENV['TWILIO_SECRET']
$twilio = Twilio::REST::Client.new account_sid, auth_token

from = "+14159998888" # Your Twilio number
