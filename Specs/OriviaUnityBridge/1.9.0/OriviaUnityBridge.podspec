Pod::Spec.new do |s|
  s.name         = 'OriviaUnityBridge'
  s.version      = '1.9.0'
  s.summary      = 'OriviaUnityBridge binary distribution'
  s.homepage     = 'https://orivia.ai'
  s.license = {
    :type => 'Commercial',
    :text => <<-LICENSE
Copyright 2026 Orivia Limited.
All rights reserved.

The Orivia SDK is available under a commercial license (https://orivia.ai/#terms).
Contact serhii@orivia.ai for details.
    LICENSE
  }
  s.author       = { 'Orivia Limited' => 'serhii@orivia.ai' }
  s.platform     = :ios, '12.0'

  s.source = {
    :http => 'https://github.com/orivia-ai/orivia-specs/releases/download/1.9.0/OriviaUnityBridge.xcframework.zip'
  }

  s.vendored_frameworks = 'OriviaUnityBridge.xcframework'
  s.swift_version       = '5.0'

  s.dependency 'OriviaMonetization', '1.9.0'
end