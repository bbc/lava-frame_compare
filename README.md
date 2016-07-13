#Lava Frame Compare

Helpers for analysing video frames and screenshots over a testing session,
analyzing them, and stitching them together for later playback.

We use our lava libs for checking video playback on our device tests.

## Why would you use it?

We run a lot of tests that capture screenshots or look at video playback. 
Often we'll take several screenshots or video samples over the duration 
of a test and we wanted some way of comparing
the captures over the test run in order to determine if video playback is
working.

Lava performs a diff between frames and returns an integer representing
the amount of change between screenshots. A value of zero indicates the
frames are identical. Whereas a value in the thousands indicates a large
differential between the frames. We find this diff technique gives us a
good indication that video is playing in our tests, and will also spot
buffering problems and crashes (the diff value drops significantly).

Lava also stitches together the frames captured over a session to create
an animated gif that is a handy reference for checking why a particular test
failed.

## Dependencies

The gem is very simple and doesn't do any captures itself -- you'll need to
have some mechanism for doing that. We use the device_api gem for
grabbing screenshots from physical android and ios devices.

The gem uses [ImageMagick](http://www.imagemagick.org/) to perform the
frameshot comparisons -- you will need to install this dependency first.

## Usage example

You first need to define a lambda for performing a capture. For example,
using the device_api we might do:

    take_screenshot = ->(filename) {
      device.screenshot(:filename => filename)
    }
    
You can then use that lambda with Lava to establish a capture session,
giving it a directory where you want the screen shots.
    
    session = Lava::FrameCompare.start_session( :name => 'test-01', :capture => take_screenshot, :dir => 'captures' )
    
    # Call capture for the initial screenshot
    frame = session.capture

    # session.diff performs a screenshot and does the diff
    10.times do
      puts session.diff
    end

    # Finish the session and create the composite
    session.end( file: './composite.gif' )

There are a number of options for generating the composit file:

    # Create a significantly smaller gif file by skipping every other frame
    session.end( :step => 2 )
    
    # Speed up the gif playback
    session.end( :speed => 5) # 5x speed
    
    # Rotate the image
    session.end( :rotate => 90 ) # 90 degrees
    
    # Set the max dimensions of the image
    session.end( :max_width => 100, :max_height => 100 )
    
## License

Lava is available to everyone under the terms of the MIT open source licence. Take a look at the LICENSE file in the code.

Copyright (c) 2016 BBC

