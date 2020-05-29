Pod::Spec.new do |s|
  s.name         = "Euler"
  s.version      = "0.1"
  s.summary      = "The open source computational framework for the Swift language (early stage)"
  s.description  = <<-DESC
    The open source computational framework for the Swift language (early stage)
  DESC
  s.homepage     = "https://github.com/arguiot/Euler"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Arthur Guiot" => "arguiot@gmail.com" }
  s.social_media_url   = ""
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/arguiot/Euler.git", :branch => "xcode-proj" }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
