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

    s.ios.deployment_target = '10.3'

    s.default_subspec = "Lirika"
    s.source_files = 'CoordinatorExperiment/common/coordinator/**/*.swift'

  s.subspec "Lirika" do |ss|
    ss.source_files  = "CoordinatorExperiment/common/coordinator/**/*.swift"
    ss.framework  = "Foundation"
  end