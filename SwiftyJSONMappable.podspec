
Pod::Spec.new do |s|

  s.name         = "SwiftyJSONMappable"
  s.version      = "0.1.0"
  s.summary      = "SwiftyJSON extensions JSON->Model  Model->JSON  model->JSONString."
  s.description  = <<-DESC
				JSONMappable implement [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
                     DESC

  s.homepage     = "https://github.com/ApterKing/SwiftyJSONMappable"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "ApterKing" => "wangcccong@outlook.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "8.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/ApterKing/SwiftyJSONMappable.git", :tag => "#{s.version}" }

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true
  s.default_subspec = "Mappable"

  s.subspec "Mappable" do |ss|
	ss.source_files = "Pod/Classes/JSONMappable.swift"	
  	ss.dependency "SwiftyJSON", "~>3.1.4"
  	ss.frameworks = "Foundation"
  end

end
