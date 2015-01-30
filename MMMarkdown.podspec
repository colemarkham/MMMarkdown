Pod::Spec.new do |s|
  s.name          = "MMMarkdown"
  s.version       = "0.4.1"
  s.summary       = "An Objective-C static library for converting Markdown to HTML."
  s.homepage      = "https://github.com/colemarkham/MMMarkdown"
  s.license       = "MIT"
  s.authors        = { "Matt Diephouse" => "matt@diephouse.com", "Cole Markham" => "cole@ccmcomputing.net" }
  s.source        = { :git => "https://github.com/colemarkham/MMMarkdown.git", :tag =>  "#{s.version}" }
  s.platform      = :ios, "7.0"
  s.source_files  = "*.{h,m}"
  s.requires_arc  = true
end
