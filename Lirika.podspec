Pod::Spec.new do |s|
  s.name                  = "Lirika"
  s.version               = "0.2"
  s.summary               = "Lirika coordinator"
  s.description           = <<-DESC
  Simple way to coordinate your controllers
  DESC

  s.homepage              = "https://github.com/alobanov/Lirika"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "Lobanov Aleksey" => "lobanov.aw@gmail.com" }
  s.source                = { :git => "https://github.com/alobanov/Lirika.git", :tag => s.version.to_s }
  s.social_media_url      = "https://twitter.com/alobanov"

  s.source_files = 'sources/**/*.swift'
  s.swift_version = '5.0'
  s.ios.deployment_target = "10.0"
  s.requires_arc = true
end
