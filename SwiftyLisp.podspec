Pod::Spec.new do |s|
  s.name         = "SwiftyLisp"
  s.version      = "1.0.3"
  s.summary      = "An embeddable LISP interpreter"
  s.description  = <<-DESC
    A LISP interpreter based on McCarthy micro-manual paper.
  DESC
  s.homepage     = "https://github.com/uraimo/SwiftyLisp"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = "Umberto Raimondi"
  s.social_media_url   = "https://twitter.com/uraimo"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/uraimo/swiftylisp.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
