Gem::Specification.new do |s|
  s.name        = 'lava-frame_compare'
  s.version     = '0.1.0'
  s.date        = '2015-02-25'
  s.summary     = 'Lava FrameCompare'
  s.description = 'Analysis tool for performing video frame comparisons'
  s.authors     = ['BBC', 'David Buckhurst']
  s.email       = 'david.buckhurst@bbc.co.uk'
  s.files       = [ 'lib/lava/frame_compare.rb', 'lib/lava/sample.rb', 'lib/lava/session.rb' ]
  s.homepage    = 'https://github.com/bbc/lava-frame_compare'
  s.license     = 'MIT'
  s.add_runtime_dependency 'rmagick'
end
