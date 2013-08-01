# motion-aws

Provides iOS and OSX connectivity to AWS services.

## Installation

    gem 'motion-aws', "~> 0.0.1"

## Config

You need to provide your AWS security credentials and choose a default region.

    MotionAWS.config(access_key_id: '...', secret_access_key: '...', region: 'us-west-2')

## Usage

### Amazon S3

Currently in progress.

    MotionAWS::S3

### Amazon Glacier

Currently in progress.

    MotionAWS::Glacier

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
