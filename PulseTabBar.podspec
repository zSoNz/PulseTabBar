Pod::Spec.new do |s|
  s.name      = "PulseTabBar"
  s.version   = "1.0.0"
  s.swift_version = "5.0"
  s.summary   = "Animated UITabBarController subclass."
  s.description  = "UITabBarController subclass that provides an animated tab bar with a unique distortion effect when switching between tabs."
  s.homepage  = "https://github.com/zSoNz/PulseTabBar"
  s.license   = { :type => "New BSD", :file => "LICENSE" }
  s.author    = { "Bohdan" => "xzsonzx@gmail.com" }
  s.source    = { :git => "https://github.com/zSoNz/PulseTabBar",
                  :tag => s.version.to_s }

  # Platform setup
  s.requires_arc          = true
  s.ios.deployment_target = '13.0'

  # Preserve the layout of headers in the Module directory
  s.header_mappings_dir   = 'Source'
  s.source_files          = 'Source/**/*.{swift,h,m,c,cpp}'
end
