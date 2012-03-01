require 'digest/md5'
require 'active_support'
require "net/https"
require 'uri'

class ReferralCandy
  VERIFY_URL   = "https://my.referralcandy.com/api/v1/verify.json"
  PURCHASE_URL = "https://my.referralcandy.com/api/v1/purchase.json"
  REFERRALS_URL = "https://my.referralcandy.com/api/v1/referrals.json"

  attr_reader :secret_key, :access_id

  def initialize(access_id, secret_key)
    @access_id  = access_id
    @secret_key = secret_key
  end

  def verify
    res_hash = do_http_request(VERIFY_URL, Hash.new, :get)
    res_hash['http_code'] == '200' ? true : false
  end

  def purchase params
    res_hash = do_http_request PURCHASE_URL, params, :post
  end

  def referrals period_from, period_to, customer_email
    params = {
      :period_from => period_from,
      :period_to => period_to,
      :customer_email => customer_email
    }
    do_http_request REFERRALS_URL, params, :get
  end

  private

  def do_http_request url, in_params, method
    timestamp = Time.now.to_i
    params = in_params.merge({
      :accessID  => self.access_id,
      :timestamp => timestamp
    })
    params[:signature] = signature(params)

    uri          = URI.parse(url)
    uri.query    = params.to_query
    http         = Net::HTTP.new(uri.host, 443)
    http.use_ssl = true
    res = if method == :post
            http.post(uri.path, uri.query)
          else
            http.get(uri.request_uri)
          end
    api_response(res.body, res.code)
  end

  def api_response response_body, code
    (JSON.parse(response_body) rescue {}).merge({
      'http_code' => code
    })
  end

  def signature params = {}
    collected_params = params.map{|k, v| "#{k}=#{v}"}.sort.join
    Digest::MD5.hexdigest(self.secret_key + collected_params)
  end

end

