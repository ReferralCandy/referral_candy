# -*- encoding: utf-8 -*-
require File.expand_path('../lib/referral_candy/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'referral_candy'
  s.version       = ReferralCandy::VERSION.dup
  s.date          = '2011-12-12'
  s.summary       = "ReferralCandy Ruby API Client"
  s.description   = "Ruby wrapper for ReferralCandy API"
  s.authors       = ["Yinquan Teo", "Sean Xie Sheng Xiang", "Dinesh Raju"]
  s.email         = 'hello@referralcandy.com'
  s.homepage      = 'http://www.referralcandy.com/api'

  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^(spec)/})
  s.require_paths = ["lib"]

  s.add_dependency             "httparty", ">= 0.8.0"
  s.add_development_dependency "rspec", "~> 2.9.0"

end
