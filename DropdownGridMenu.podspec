Pod::Spec.new do |s|
  s.name             = 'DropdownGridMenu'
  s.version          = '1.0.2'
  s.summary          = 'Dropdown grid menu for iOS.'

  s.description      = <<-DESC
Dropdown grid menu for iOS written in Swift. The menu can be presented from a navigation bar button item, in fullscreen or in a popover.
                       DESC

  s.homepage         = 'https://github.com/ochornenko/DropdownGridMenu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Oleg Chornenko' => 'oleg.chornenko@icloud.com' }
  s.source           = { :git => 'https://github.com/ochornenko/DropdownGridMenu.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/OlegCo'

  s.ios.deployment_target = '10.0'

  s.source_files = 'DropdownGridMenu/**/*'
  s.frameworks = 'UIKit'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
end
