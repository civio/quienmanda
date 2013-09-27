CarrierWave.configure do |config|
  config.fog_credentials = {
    # Configuration for Amazon S3 should be made available through an Environment variable.
    # For local installations, export the env variable through the shell OR
    # if using Passenger, set an Apache environment variable.
    # In Heroku, follow http://devcenter.heroku.com/articles/config-vars
    #
    # $ heroku config:add S3_KEY=your_s3_access_key S3_SECRET=your_s3_secret S3_REGION=eu-west-1 S3_BUCKET_NAME=s3_bucket/folder
    :provider               => 'AWS',                           # required
    :aws_access_key_id      => ENV['S3_KEY'],                   # required
    :aws_secret_access_key  => ENV['S3_SECRET'],                # required
    :region                 => ENV['S3_REGION']                 # optional, defaults to 'us-east-1'
    # :host                   => 's3.example.com',              # optional, defaults to nil
    # :endpoint               => 'https://s3.example.com:8080'  # optional, defaults to nil
  }

  config.fog_directory  = ENV['S3_BUCKET_NAME']                    # required
  # config.fog_public     = false                                  # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}   # optional, defaults to {}

  # For testing, upload files to local `tmp` folder.
  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.root = "#{Rails.root}/tmp"
    config.enable_processing = false
  elsif Rails.env.development? and ENV['FORCE_S3_IN_DEV']!='true'
    config.storage = :file
  else
    config.storage = :fog
  end
   
  config.cache_dir = "#{Rails.root}/tmp/uploads" # To let CarrierWave work on heroku
end
