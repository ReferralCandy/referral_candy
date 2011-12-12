Gem::Specification.new do |s|
  s.name          = 'referral_candy'
  s.version       = '0.0.1'
  s.date          = '2011-12-12'
  s.summary       = "ReferralCandy API"
  s.description   = "Ruby wrapper for ReferralCandy API"
  s.authors       = ["Yinquan Teo", "Zaizhuang Cheng"]
  s.email         = 'hello@referralcandy.com'
  s.homepage      = 'http://www.referralcandy.com/api'

  s.files         =  Dir.glob("{lib,spec}/**/*")
  s.files         += ["referral_candy.gemspec"]

  s.require_paths = ["lib"]

  s.add_dependency             "activesupport", ">= 2.3.5"
  s.add_development_dependency "rspec", "1.3.2"

end
