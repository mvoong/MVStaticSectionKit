Pod::Spec.new do |s|
  s.name             = "MVStaticSectionKit"
  s.version          = "0.1.0"
  s.summary          = "Utilize the builder pattern to remove boilerplate UITableViewDataSource code."

  s.description      = <<-DESC
    Supports one NSFetchedResultsController per section, and also mixing static and dynamic sections. UICollectionViewDataSource support
    coming.
                       DESC
                       
  s.homepage         = "https://github.com/mvoong/MVStaticSectionKit"
  s.license          = 'MIT'
  s.author           = { "Michael Voong" => "michael@voo.ng" }
  s.source           = { :git => "https://github.com/mvoong/MVStaticSectionKit.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
