Pod::Spec.new do |s|
  s.name             = "DMPasscode"
  s.version          = "1.3.0"
  s.summary          = "Passcode screen with Touch ID support"
  s.homepage         = "https://github.com/d-32/DMPasscode"
  s.license          = 'Public Domain'
  s.author           = { "Dylan Marriott" => "info@d-32.com" }
  s.source           = { :git => "https://github.com/d-32/DMPasscode.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/dylan36032"
  s.screenshot  	 = "http://46.105.26.1/uploads/passcode.png"

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = { 'DMPasscode' => 'Pod/Assets/*.lproj' }

  s.public_header_files = 'Pod/Classes/DMPasscode.h', 'Pod/Classes/DMPasscodeConfig.h'
  s.frameworks = 'UIKit', 'Security', 'LocalAuthentication'
end
