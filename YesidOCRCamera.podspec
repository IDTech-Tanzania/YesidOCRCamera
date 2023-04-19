Pod::Spec.new do |s|
  s.name             = 'YesidOCRCamera'
  s.version          = '0.1.0'
  s.summary          = 'YesidOCRCamera is a SwiftUI library for capturing and processing identity cards and passports using OCR and images.'
  s.description      = "YesidOCRCamera is a library designed to simplify the process of capturing and processing identity cards and passports using OCR and images in a SwiftUI app. It provides a straightforward interface for capturing images and extracting relevant information, such as text and metadata, from them. The library utilizes the GoogleMLKit/ObjectDetectionCustom dependency for object detection and classification, ensuring reliable and accurate processing. The library also includes a resource bundle with pre-built assets, making it easy to integrate into your app."
  s.homepage         = 'https://github.com/IDTech-Tanzania/YesidOCRCamera'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Emmanuel Mtera' => 'emtera@yesid.io' }
  s.source = {:http => 'https://raw.githubusercontent.com/IDTech-Tanzania/YesidOCRCamera/main/YesidOCRCamera.zip'}
  s.ios.vendored_frameworks = 'YesidOCRCameraFramework.framework'
  s.ios.deployment_target = '13.0'
  s.swift_versions = ['5.0']
  s.exclude_files = "Classes/Exclude"
  s.source_files = 'Users/intisarhamza/yesid-ios/NewFrameworks/YesidOCRCamera'
  
  s.dependency 'GoogleMLKit/ObjectDetectionCustom', '~> 3.2.0'
  #s.static_framework = true
  
end
