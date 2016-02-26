require 'lava/session'

RSpec.describe Lava::Session do
  
  let(:dumb_lambda) { lambda { |filename| } }
  let(:tmp_dir) { "/tmp/lava/spec/#{rand(10000)}" }
  
  let(:good_capture) do
    lambda { |filename| FileUtils.cp( 'spec/assets/grass.png', filename ) } 
  end
      
  let(:good_capture_2) do
    lambda { |filename| FileUtils.cp( 'spec/assets/grass_2.png', filename ) } 
  end

  
  describe ".initialize" do
    it "creates a lava session object" do
      expect( Lava::Session.new( frame_capture: dumb_lambda ) ).to be_a Lava::Session
    end
    
    it "raises an exception if a frame_capture lambda is not provided" do
      expect { Lava::Session.new }.to raise_error(ArgumentError)
    end
    
    context "creation of capture directory" do
      
      
      it "creates the capture directory specified by the argument" do
        session = Lava::Session.new( frame_capture: dumb_lambda, dir: tmp_dir )
        expect(session.dir).to eq tmp_dir
        expect( File.directory?(tmp_dir) ).to be true
      end
      
      it "creates a capture directory anyway if one is not specified" do
        session = Lava::Session.new( frame_capture: dumb_lambda )
        expect( File.directory?(session.dir) ).to be true
      end
      
    end
  end
  
  describe "#capture" do
    
    context "successfully capturing frame" do
      
      let(:session) do
        l = lambda { |filename| FileUtils.cp( 'spec/assets/grass.png', filename ) } 
        Lava::Session.new( frame_capture: l )
      end
    
      it "should return a sample object" do
        expect( session.capture ).to be_a Lava::Sample
      end
      
      it "should have a diff of zero" do
        expect( session.diff ).to eq 0
      end
      
    end
 
    context "handling corrupt captures" do
      
      let(:bad_capture) do
        lambda { |filename| FileUtils.cp( 'spec/assets/corrupt.png', filename ) } 
      end

      it "discards corrupt captures" do
        
        session = Lava::Session.new( frame_capture: good_capture )
        session.capture
        
        session.frame_capture = bad_capture
        expect { session.capture }.to raise_error(Magick::ImageMagickError)
        
        session.frame_capture = good_capture_2
        sample = session.capture
        
        expect( session.samples.count ).to eq 2
        expect( sample.diff ).to eq 8845
         
      end
      
    end
    
  end
  
  describe "#end" do
    
    let(:session) do
      session = Lava::Session.new( frame_capture: good_capture )
      session.capture
      session.frame_capture = good_capture_2
      session.capture
      session.frame_capture = good_capture
      session.capture
      session.frame_capture = good_capture_2
      session.capture
      session
    end
    
    let(:gif_file) { "/tmp/lava/spec/#{rand(10000)}.gif" }
    
    it "creates an animated gif upon completion" do
      session.end(:file => gif_file)
      expect( File.exist? gif_file ).to be true
      expect( File.size(gif_file) ).to be > 1000000
      expect( `file #{gif_file}` ).to match /GIF\simage\sdata.*750 x/
    end
    
    it "takes a rotation argument for changing orientation" do
      session.end(:file => gif_file, :rotate => 90)
      expect( File.exist? gif_file ).to be true
      expect( `file #{gif_file}` ).to match /GIF\simage\sdata.*x 750/
    end
    
    it "takes a sample argument for creating a smaller gif file" do
      session.end(:file => gif_file, :step => 2 )
      expect( File.exist? gif_file ).to be true
      expect( File.size(gif_file) ).to be < 600000
      p gif_file
      expect( `file #{gif_file}` ).to match /GIF\simage\sdata.*750 x/
    end
    
  end
end
