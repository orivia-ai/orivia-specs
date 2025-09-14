Pod::Spec.new do |s|
  s.name         = 'OriviaMonetization'
  s.version      = '$VERSION'
  s.summary      = 'OriviaMonetization binary distribution'
  s.homepage     = 'https://orivia.ai'
    s.license = {
    :type => 'Commercial',
    :text => <<-LICENSE
Copyright 2025 Orivia Limited.
All rights reserved.

The Orivia SDK is available under a commercial license (https://orivia.ai/#terms).
Contact serhii@orivia.ai for details.
    LICENSE
  }
  s.author       = { 'Orivia Limited' => 'serhii@orivia.ai' }
  s.platform     = :ios, '12.0'

  s.source = {
    :http => ''
  }

  s.vendored_frameworks = 'OriviaMonetization.xcframework'
  s.swift_version       = '5.0'
end