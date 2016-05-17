Pod::Spec.new do |s|
  s.name             = "AYRoundedProgress"
  s.version          = "1.0.2"
  s.summary          = "Vertical rounded progress with predefined steps."
  s.license          = 'MIT'
  s.homepage         = 'https://github.com/andjash/AYRoundedProgress'
  s.author           = { "Andrey Yashnev" => "andjash@gmail.com" }
  s.source           = { :git => "https://github.com/andjash/AYRoundedProgress.git", :tag => s.version.to_s }

  s.platform     = :ios, '6.0'

  s.source_files = 'AYRoundedProgress'

end
