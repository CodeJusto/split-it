$amazon_request = Vacuum.new('CA')

$amazon_request.configure(
  aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
  aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
  associate_tag: ENV["ASSOCIATE_TAG"]
)

$amazon_request.version = '2013-08-01'