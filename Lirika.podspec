Pod::Spec.new do |s|
  s.name                  = "Lirika"
  s.version               = "0.1"
  s.summary               = "Lirika coordinator"
  s.description           = <<-DESC
  Simple way to coordinate your controllers
  DESC

  s.homepage              = "https://github.com/alobanov/Lirika"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "Lobanov Aleksey" => "lobanov.aw@gmail.com" }
  s.source                = { :git => "https://github.com/alobanov/Lirika.git", :tag => s.version.to_s }
  s.social_media_url      = "https://twitter.com/alobanov"

  s.default_subspec = "Lirika"
  s.source_files = 'CoordinatorExperiment/common/coordinator/**/*.swift'

  s.swift_version = '4.2'
  s.swift_versions = ['4.2', '5.0']

  s.ios.deployment_target = "10.0"
end
