require 'rmagick'
require 'fileutils'
require 'lava/sample'

module Lava

  DEFAULT_TMP_DIR = '/tmp/lava'
  DEFAULT_MAX_HEIGHT = 750
  DEFAULT_MAX_WIDTH = 750
  DEFAULT_SPEED = 2

  
  # Main class for managing the capture sessions
  class Session
    
    attr_accessor :name, :dir, :samples, :frame_capture, :audio_sampler
    
    # Initialize a capture session
    def initialize( args = {} )
      @name = args[:name] || Time.now.to_i
      @dir = args[:dir] || "#{DEFAULT_TMP_DIR}/#{@name}"
      @frame_capture = args[:frame_capture] or raise ArgumentError, 'Need to provide a lambda to the constructor'
      @audio_sampler = args[:audio_sampler]
      @samples = []
      FileUtils.mkdir_p(@dir)
      File.directory?(@dir) or raise "Couldn't create session directory for screen grabs"
    end
 
    # Perform a frame capture
    def capture
      filename = Time.now.to_f.to_s + '.png'
      
      file = "#{dir}/#{filename}"
      
      capture_time = Time.now
      
      @frame_capture.call(file)
      volume = @audio_sampler.call(file) if @audio_sampler
      
      File.exist? file or raise "Couldn't capture frame"

      sample = Lava::Sample.new( :file => file, :time => capture_time, :last => samples.last, :volume => volume )
      samples << sample
      sample
    end
    
    # Performs a capture and diffs it with the last image
    def diff
      if samples.count == 0
        self.capture
      end
      
      current = self.capture
      
      current.diff
    end
    
    # Finalize the capture session, and create an animated gif
    # of the capture session
    def end(args = {})
      
      if args[:file]
        file = args[:file]
      else
        if !args[:filename]
          file = "#{@dir}/#{@name}.gif"
        else
          file = "#{@dir}/#{filename}"
        end
      end
      
      rotate = args[:rotate] || 0
      step = args[:step] || 1
      max_width = args[:max_width] || Lava::DEFAULT_MAX_WIDTH
      max_height = args[:max_height] || Lava::DEFAULT_MAX_HEIGHT
      speed = args[:speed] || Lava::DEFAULT_SPEED
      
      
      rimages = Magick::ImageList.new
      (0 ... samples.count ).step(step).each do |i|
        s = samples[i]
        s.rimage.rotate! rotate
        s.rimage.resize_to_fit!(max_width, max_height)
        rimages << s.rimage
      end
      rimages.ticks_per_second = speed
      rimages.write(file)
    end
    
  end
   
end
