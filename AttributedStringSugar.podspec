#
# Be sure to run `pod lib lint AttributedStringSugar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AttributedStringSugar'
  s.version          = '1.0.0'
  s.swift_versions   = '5.0'
  s.summary          = 'NSAttributedString sugar using builder pattern.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  NSAttributedString sugar using builder pattern
  using like this
  ```swift
    let text = "Hello".attribute
            .systemFont(ofSize: 20, weight: .bold)
            .paragraphStyle(alignment: .center)
  ```
                       DESC

  s.homepage         = 'https://github.com/ElonPark/AttributedStringSugar'
  s.screenshots      = 'https://user-images.githubusercontent.com/13270453/77228119-7348bf00-6bc8-11ea-95c4-06c624ff8ca3.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ElonPark' => 'dev.sungwoon@gmail.com' }
  s.source           = { :git => 'https://github.com/ElonPark/AttributedStringSugar.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'AttributedStringSugar/Classes/**/*'

  s.frameworks = 'UIKit'
end
