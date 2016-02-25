require 'lava/sample'
require 'rmagick'

RSpec.describe Lava::Sample do
  
  context "no previous samples" do
    
    describe ".initialize" do
    
      let(:sample) { Lava::Sample.new( file: 'spec/assets/grass.png' )  }
    
      it "creates a lava sample object" do
        expect( sample ).to be_a Lava::Sample
      end
      
      it "creates an internal rmagick representation" do
        expect( sample.rimage ).to be_a Magick::Image
      end
      
    end
  
  end

  context "diffing multiple samples" do
  
    let(:sample_1) { Lava::Sample.new( file: 'spec/assets/grass.png' )  }
    let(:sample_2) { Lava::Sample.new( file: 'spec/assets/grass_2.png', last: sample_1 )  }
    let(:sample_3) { Lava::Sample.new( file: 'spec/assets/grass_2.png', last: sample_2 )  }
  
    describe "#raw" do
      
      let(:analysis) { sample_2.raw }
      
      it "returns a hash of analysis data" do
        expect(analysis).to be_a Hash
      end
      
      it "contains a diff between" do
        expect( analysis[:mean_error_per_pixel].to_i ).to eq 8845
      end
      
    end
    
    describe "#diff" do
      it "produces a zero diff for the first image" do
        expect( sample_1.diff ).to eq 0
      end
      
      it "produces a large diff for the second image" do
        expect( sample_2.diff ).to eq 8845
      end
      
      it "produces a zero diff for an identical image" do
        expect(sample_3.diff).to eq 0
      end
    end
    
  end
  
  context "corrupt or missing images" do
    let(:sample_1) { Lava::Sample.new( file: 'spec/assets/grass.png' )  }
    
    it "raises an exeption when image is corrupt" do
      expect { Lava::Sample.new( file: 'spec/assets/corrupt.png', last: sample_1 ) }.to raise_error Magick::ImageMagickError
    end
  end

end
    
