require 'digest/md5'
require 'httparty'

class ReferralCandy
  DEFAULT_API_URL = "https://my.referralcandy.com/api/v1/"
  API_METHODS = {
    get:  [:verify, :referrals, :referrer, :contacts],
    post: [:purchase, :referral, :signup, :invite]
  }

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

  def initialize(options = {})
    @access_id  = options[:access_id]
    @secret_key = options[:secret_key]
  end

  API_METHODS.each do |verb, end_points|
    end_points.each do |ep|
      class_eval <<-EVAL
        def #{ep}(params = {})
          ReferralCandy.#{verb}("/#{ep}.json", query: add_signature_to(params))
        end
      EVAL
    end
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
