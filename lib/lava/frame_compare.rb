require 'lava/session'

module Lava
  
  class FrameCompare
    
    
    # Initialize a frame comparison session
    # Takes a number of args:
    # * name (optional) -- name for the session
    # * dir (optional) -- directory to store frame captures
    # * frame_capture (required) -- lambda for performing a frame capture
    # The lambda should take a single argument, filename:
    #         capture_frame = ->(filename) {
    #           code_to_perform_frame_capture( :save_to => filename )
    #         }
    def self.start_session( args )
    
      raise "frame_capture lambda function required" if !args[:frame_capture] || args[:capture]
    
      Lava::Session.new( :name          => args[:name],
                         :frame_capture => args[:frame_capture] || args[:capture],
                         :dir           => args[:dir],
                         :audio_sample  => args[:audio_sample] )
    
    end
    
  end
     
end
