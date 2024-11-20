#
# Be sure to run `pod lib lint mtg-sdk-swift.podspec' to ensure this is a
# valid spec before submitting.
#

 Pod::Spec.new do |s|
  s.name             = 'MTGSDKSwift'
  s.version          = '1.1.1'
  s.summary          = 'Magic: The Gathering SDK - Swift'
  s.description      = <<-DESC
  A lightweight framework that makes interacting with the magicthegathering.io api quick, easy and safe.
                       DESC

  s.homepage         = 'https://github.com/MagicTheGathering/mtg-sdk-swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Reed Carson' => 'rpcarson27@gmail.com' }
  s.source           = { :git => 'https://github.com/MagicTheGathering/mtg-sdk-swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.2'
  s.osx.deployment_target  = '12.4'
  s.source_files = 'MTGSDKSwift/**/*.swift'
  s.swift_version = '4.1'
 end
