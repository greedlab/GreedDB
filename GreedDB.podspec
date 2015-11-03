Pod::Spec.new do |s|

  s.name         = "GreedDB"
  s.version      = "0.0.3"
  s.summary      = "convenient storage for ios"

  s.description  = %{
    this is a storage manager for ios. based on FMDB and GreedJSON. can save NSDictionary,NSArray,NSData,NSString,NSNumber or NSObject  directly }

  s.homepage     = "https://github.com/greedlab/GreedDB"

  s.license      = "MIT"

  s.author             = { "Bell" => "bell@greedlab.com" }

   s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/greedlab/GreedDB.git", :tag => s.version }

  s.source_files  = "GreedDB", "GreedDB/*.{h,m}"

   s.framework  = "Foundation"

   s.requires_arc = true

   s.dependency "FMDB"
   s.dependency "GreedJSON"

end
