require 'lava/session'

module Lava
  
  class FrameCompare
    
    
    # Initialize a frame comparison session
    # Takes a number of args:
    # * name (optional) -- name for the session
    # * dir (optional) -- directory to 
    # * capture (required) -- lambda for performing a screenshot
    # The lambda should take a single argument filename:
    #         capture_frame = ->(filename) {
    #           code_to_perform_frame_capture( :save_to => filename )
    #         }
    def self.start_session( args )
    
      Lava::Session.new( :name => args[:name], :capture => args[:capture], :dir => args[:dir] )
    
    end
    
  end
     
end
