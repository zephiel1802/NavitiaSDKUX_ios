#
# Be sure to run `pod lib lint NavitiaSDKUX.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NavitiaSDKUX'
  s.version          = '0.2.1'
  s.summary          = 'An awesome framework to offer cool transport stuff to your users'

  s.description      = <<-DESC
An awesome framework to offer cool transport stuff to your users
                       DESC

   s.homepage         = 'https://github.com/CanalTP/NavitiaSDKUX_ios'
   s.license          = { :type => 'GPL-3', :file => 'LICENSE' }
   s.author           = { 'Kisio Digital' => 'contact@kisio.org' }
   s.source           = { :git => 'https://github.com/CanalTP/NavitiaSDK_ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'NavitiaSDKUX/Classes/**/*'
  s.resources = 'NavitiaSDKUX/Assets/**/*'

  s.dependency 'Render', '~> 4.9.1'
  s.dependency 'NavitiaSDK', '0.3.1'
end
