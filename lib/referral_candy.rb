require 'digest/md5'
require 'httparty'

class ReferralCandy
  DEFAULT_API_URL = "https://my.referralcandy.com/api/v1/"

  include  HTTParty
  base_uri DEFAULT_API_URL
  format   :json

  attr_reader :secret_key, :access_id
  class << self
    def api_url= url
      base_uri url
      @api_url = url
    end
    def api_url
      @api_url || DEFAULT_API_URL
    end
  end

  def initialize(access_id, secret_key)
    @access_id  = access_id
    @secret_key = secret_key
  end

  def verify
    ReferralCandy.get("/verify.json", :query => add_signature_to({}))
  end

  def purchase params
    ReferralCandy.post("/purchase.json", :query => add_signature_to(params))
  end

  def referrals period, customer_email
    params = {
      :period_from    => period.first,
      :period_to      => period.last,
      :customer_email => customer_email
    }
    ReferralCandy.get("/referrals.json", :query => add_signature_to(params))
  end

  def referral params
    ReferralCandy.post("/referral.json", :query => add_signature_to(params))
  end

  def referrer email_addr
    ReferralCandy.get("/referrer.json", :query => add_signature_to(:customer_email => email_addr))
  end

  def contacts params
    ReferralCandy.get("/contacts.json", :query => add_signature_to(params))
  end

  def self.get(*args, &block)
    resp = super(*args, &block)
    resp.parsed_response.merge('http_code' => resp.code)
  end

  def self.post(*args, &block)
    resp = super(*args, &block)
    resp.parsed_response.merge('http_code' => resp.code)
  end

  private

  def add_signature_to input_params
    params = input_params.merge({
      :accessID  => self.access_id,
      :timestamp => Time.now.to_i
    })
    params[:signature] = signature(params)
    params
  end

  def signature params = {}
    collected_params = params.map{|k, v| "#{k}=#{v}"}.sort.join
    Digest::MD5.hexdigest(self.secret_key + collected_params)
  end
end
