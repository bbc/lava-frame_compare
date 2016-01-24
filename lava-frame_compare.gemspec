Gem::Specification.new do |s|
  s.name        = 'lava-framecompare'
  s.version     = '0.1.0'
  s.date        = '2015-01-19'
  s.summary     = 'Lava FrameCompare'
  s.description = 'Analysis tool for comparing screenshots, video frame captures, or random images'
  s.authors     = ['David Buckhurst']
  s.email       = 'david.buckhurst@bbc.co.uk'
  s.files       = [ 'lib/lava/**.rb' ]
  s.homepage    = 'https://github.com/bbc/lava'
  s.license     = 'MIT'
  s.add_runtime_dependency 'rmagick'
end
