# encoding: UTF-8
require "spec_helper"

describe ReferralCandy do

  let(:secret_key)        { 'access_token' }
  let(:access_id)         { 'access_id' }
  let(:refcandy)          { ReferralCandy.new(access_id, secret_key) }
  let(:params)            { {:name => "john"} }
  let(:pre_signed_params) { params.merge(:accessID => access_id, :timestamp => 1) }

  describe ".initialize" do
    subject { refcandy }
    its(:secret_key) { should == secret_key }
    its(:access_id)  { should == access_id }
  end

  describe "#api_url" do
    subject { ReferralCandy }
    its(:api_url) { should == ReferralCandy::DEFAULT_API_URL }
  end

  describe ".add_signature_to" do
    it "should add accessID to params" do
      refcandy.send(:add_signature_to, params)[:accessID].should == access_id
    end
    it "should add timestamp to params" do
      Time.stub(:now).and_return(1)
      refcandy.send(:add_signature_to, params)[:timestamp].should == 1
    end
    it "should add signature to params" do
      Time.stub(:now).and_return(1)
      refcandy.send(:add_signature_to, params)[:signature].should == refcandy.send(:signature, pre_signed_params)
    end
  end
  describe ".signature" do
    it "should calculate the correct signature" do
      refcandy.send(:signature, pre_signed_params).should == '25cb1ed0c5e9e64f09fa4db9ed7ff156'
    end
  end

  describe ".verify" do
    it "should GET verify.json with correct params" do
      ReferralCandy.should_receive(:get).once.with("/verify.json", :query => refcandy.send(:add_signature_to, {}))
      refcandy.verify
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
    it "should POST purchase.json with correct params" do
      ReferralCandy.should_receive(:post).once.with("/purchase.json", :query => refcandy.send(:add_signature_to, purchase_params))
      refcandy.purchase(purchase_params)
    end
  end

  describe ".referrals" do
    let(:referrals_period) { 1330584797..1330585397 }
    let(:referrals_params) {{
      :period_from    => referrals_period.first,
      :period_to      => referrals_period.last,
      :customer_email => "customer@anafore.com"
    }}
    it "should GET referrals.json with correct params" do
      ReferralCandy.should_receive(:get).once.with("/referrals.json", :query => refcandy.send(:add_signature_to, referrals_params))
      refcandy.referrals(referrals_period, "customer@anafore.com")
    end
  end

  describe ".referrer" do
    it "should GET referrer.json with correct params" do
      ReferralCandy.should_receive(:get).once.with("/referrer.json", :query => refcandy.send(:add_signature_to, {:customer_email => "customer@anafore.com"} ))
      refcandy.referrer("customer@anafore.com")
    end
  end
end
