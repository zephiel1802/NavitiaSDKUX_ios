#
# Be sure to run `pod lib lint NavitiaSDKUX.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NavitiaSDKUX'
  s.version          = '1.1.6'
  s.summary          = 'An awesome framework to offer cool transport stuff to your users'

  s.description      = <<-DESC
This SDK provides journey computation screens you can add to your application.
                       DESC

  s.homepage         = 'https://github.com/CanalTP/NavitiaSDKUX_ios'
  s.license          = { :type => 'GPL-3', :file => 'LICENSE' }
  s.authors          = { 'Kisio Digital' => 'contact@kisio.org' }
  s.source           = { :git => 'https://github.com/CanalTP/NavitiaSDKUX_ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'NavitiaSDKUX/Classes/**/*.swift', 'NavitiaSDKUX/Classes/**/*.h', 'NavitiaSDKUX/Classes/**/*.c', 'NavitiaSDKUX/Classes/**/*.m', 'NavitiaSDKUX/Classes/**/*.mm'
  s.resources = 'NavitiaSDKUX/Assets/**/*.*'
end
