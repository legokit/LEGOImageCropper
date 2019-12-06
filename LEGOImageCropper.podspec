#
# Be sure to run `pod lib lint LEGOImageCropper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LEGOImageCropper'
  s.version          = '1.0.0'
  s.summary          = 'Picture cropper, support to resizeWHScale, set size, rotate angle, fine adjust angle, crop product image. 图片裁剪，支持大小缩放，设置大小，旋转角度，微调角度，裁剪产品图片。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/legokit/LEGOImageCropper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '564008993@qq.com' => 'yangqingren@yy.com' }
  s.source           = { :git => 'https://github.com/legokit/LEGOImageCropper.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LEGOImageCropper/Classes/**/*'
  
end
