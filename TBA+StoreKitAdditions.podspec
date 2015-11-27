Pod::Spec.new do |s|
  s.name		= 'TBA+StoreKitAdditions'
  s.version		= '1.0.0'
  s.summary		= 'StoreKit additions'
  s.homepage		= 'http://www.thebinaryarchitect.com'
  s.license		= 'MIT'
  s.author		= { 'tba' => 'thebinaryarchitect@gmail.com'}
  s.source		= { :git => 'https://thebinaryarchitect@bitbucket.org/thebinaryarchitect/mussels.git', :branch => 'master' }

  s.platform		= :ios, '7.0'
  s.requires_arc	= true
  
  s.source_files	= 'StoreKit/*.{h,m}'

  s.module_name		= 'TBA_StoreKitAdditions'
end