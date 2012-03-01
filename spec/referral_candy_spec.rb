# encoding: UTF-8
require "spec_helper.rb"

describe ReferralCandy do

  let(:secret_key) { 'access_token' }
  let(:access_id) { 'access_id' }
  let(:refcandy) { ReferralCandy.new(access_id, secret_key) }

  describe ".initialize" do
    subject { refcandy }
    its(:secret_key) { should == secret_key }
    its(:access_id) { should == access_id }
  end

  describe ".signature" do
    it "should calculate the correct signature" do
      params = {
        :name => "john"
      }
      refcandy.send(:signature, 1, params).should == '25cb1ed0c5e9e64f09fa4db9ed7ff156'
    end
  end

  describe ".verify" do

    it "should calculate correct signature with no params" do
      refcandy.stub(:do_http_request).and_return({'http_code' => '200'})
      refcandy.should_receive(:signature).once
      refcandy.verify
    end
    it "should do http request" do
      refcandy.should_receive(:do_http_request).once.and_return({'http_code' => '200'})
      refcandy.verify
    end
    it "should return false if http code is 401" do
      refcandy.stub(:do_http_request).and_return({'http_code' => '401'})
      refcandy.verify.should be_false
    end
    it "should return true if http code is 200" do
      refcandy.stub(:do_http_request).and_return({'http_code' => '200'})
      refcandy.verify.should be_true
    end
  end

  describe ".purchase" do
    let(:purchase_params) {{
      :first_name      => "John",
      :last_name       => "Doe",
      :email           => "john@doe.com",
      :order_timestamp => Time.now.to_i,
      :browser_ip      => "123.123.123.123",
      :user_agent      => "I like iOS",
      :invoice_amount  => 500,
    }}
    it "should do http request" do
      refcandy.should_receive(:do_http_request).once.and_return({'http_code' => '200'})
      refcandy.purchase(purchase_params)
    end
  end

  describe ".referrals" do
    it "should do http request" do
      refcandy.stub(:do_http_request).and_return({'http_code' => '200'})
      refcandy.referrals(1330584797, 1330585397, "customer@anafore.com")["http_code"].should eql "200"
    end
  end

  describe ".api_response" do
    it "should return hash with status code for non-json body" do
      refcandy.send(:api_response, 'non-json', '500').should == {'http_code' => '500'}
    end

    it "should return the merged response and http_code" do
      body = { 'test' => "value" }.to_json
      refcandy.send(:api_response, body, '200').should == {
        'http_code' => '200',
        'test'      => "value"
      }
    end
  end

end
