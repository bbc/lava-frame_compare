module Lava
  
  # Class representing an image capture
  class Sample
    
    attr_accessor :volume, :blur, :file, :rimage, :time, :last, :raw
    
    def initialize( args = {} )
      
      @file = args[:file]
      @time = args[:time] || Time.now
      @last = args[:last]
      @volume = args[:volume]
      @raw = {};
      @rimage = Magick::ImageList.new(file).first
      enrich_previous_sample if last
      analyze
    end
    
    def enrich_previous_sample
      delay = (time - last.time).to_i
      last.rimage.delay = delay
    end
    
    def analyze
      if last
        raw[:mean_error_per_pixel], raw[:normalized_mean_error], raw[:normalized_max_error] = last.rimage.difference(rimage)
      end
      raw
    end
    
    def diff
      raw[:mean_error_per_pixel].to_i
    end
    
    
  end
     
end
