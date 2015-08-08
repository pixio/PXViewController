Pod::Spec.new do |s|
  s.name             = "PXViewController"
  s.version          = "0.1.2"
  s.summary          = "A more customizable and colorable nav bar."
  s.description      = <<-DESC
                       A set of subclasses for viewcontrollers and `UINavigationController` that allow you to have a title and a subtitle in the nav bar as well as custom font, colors, and more.
                       DESC
  s.homepage         = "https://github.com/pixio/PXViewController"
  s.license          = 'MIT'
  s.author           = { "Daniel Blakemore" => "DanBlakemore@gmail.com" }
  s.source = {
    :git => "https://github.com/pixio/PXViewController.git",
    :tag => s.version.to_s
  }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PXViewController' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'MZAppearance'
end
