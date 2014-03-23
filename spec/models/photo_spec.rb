require 'spec_helper'

describe Photo do
  context "when navigating along photos" do
    before do
      # We want two records where the ID order doesn't match the date order, to
      # make sure we're using dates to navigate, not IDs. (There are cleaner ways
      # of doing this, Timecop?, but this will do for now) 
      @recent_public_photo = create(:public_photo)
      @old_public_photo = create(:public_photo)
      @recent_public_photo.touch()
    end

    it "returns the next photo" do
      Photo.next(@old_public_photo).first.should == @recent_public_photo
    end

    it "returns the previous photo" do
      Photo.previous(@recent_public_photo).first.should == @old_public_photo
    end

    it "returns nil when reaching the end" do
      Photo.next(@recent_public_photo).first.should == nil
      Photo.previous(@old_public_photo).first.should == nil
    end
  end
end
