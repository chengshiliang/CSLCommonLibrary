Pod::Spec.new do |s|
  s.name         = 'CSLCommonLibrary'
  s.version      = '0.0.1'
  s.summary      = 'supply basic function,package basic library,like kvo,notify.'
  s.homepage     = 'https://github.com/chengshiliang/CSLCommonLibrary'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'chengshiliang' => '285928582@qq.com' }
  s.source       = { :git => 'https://github.com/chengshiliang/CSLCommonLibrary.git', :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.source_files = 'CSLCommonLibrary/*.{h,m}'
  s.requires_arc = true
  s.frameworks   = 'Foundation', 'UIKit'
end