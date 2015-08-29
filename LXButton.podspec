Pod::Spec.new do |s|
s.name = 'LXButton'
s.version = '0.0.1'
s.license = 'MIT'
s.summary = 'This is a custom button ,otherwise,here also has some useful categories about UIButton! '
s.homepage = 'https://github.com/LX314/LXButton'
s.author = { 'Lucky' => 'lx314333@gmail.com' }
s.source = { :git => 'https://github.com/LX314/LXButton.git', :tag => s.version.to_s }
s.platform = :ios ,'6.0'
s.source_files = 'LXButton/*'
s.requires_arc = true 
end