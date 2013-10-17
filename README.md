# ReferralCandy Ruby API Client

## Installation

    gem install 'referral_candy'

## Usage

### Initialization

Initialize a client with your ReferralCandy credentials

    rc = ReferralCandy.new(:access_id => "YOUR_ACCESS_ID", :secret_key => "YOUR_SECRET_KEY")

### Verification

Verify your credentials.

    response = rc.verify
    response.parsed_response # => {"message"=>"Verification Ok"}
    response.code            # => 200

### API Methods

The ReferralCandy API client will perform the [authentication](http://www.referralcandy.com/api#authentication) steps for you.
This means that you would not be required to pass in the 'timestamp', 'accessID', and 'signature' parameters.

[API endpoints](http://www.referralcandy.com/api) are available as methods in the ReferralCandy API client.

E.g.

    rc.contacts(:limit => 1).parsed_response
    # => {"message"=>"Success", "total_count"=>10000, "contacts"=>[{"id"=>1, "first_name"=>"Yink", "last_name"=>"Teo", "email"=>"hello@referralcandy.com", "purchase_made"=>false, "purchases"=>[], "unsubscribed"=>true}]}

## Documentation
[API documentation](http://www.referralcandy.com/api)
