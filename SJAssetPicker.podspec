
Pod::Spec.new do |s|
  s.name         = "SJAssetPicker"
  s.version      = “1.0.0”
  s.summary      = "The easiest way to picker photos."
  s.homepage     = "https://github.com/zhoushejun/SJAssetPicker"
  s.license      = "MIT"
  s.author       = { "shejunzhou" => "965678322@qq.com" }
  s.platform     = :ios, “7.0”
  s.source       = { :git => "https://github.com/zhoushejun/SJAssetPicker.git", :tag => s.version }
  s.source_files = "SJAssetPicker", "SJAssetPicker/**/*.{h,m}"
  s.resources    = "SJAssetPicker/SJAssetPickerResources/*.png"
  s.requires_arc = true
end
