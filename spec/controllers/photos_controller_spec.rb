require 'spec_helper'

describe PhotosController do
  context "an anon user" do
    before do
      @public_photo = create(:public_photo, id: 1)
      @private_photo = create(:private_photo, id: 2)
    end

    it "sees the list of published people" do
      get :index
      assert_template :index
      assigns(:photos).should == [@public_photo]
    end

    it "sees a published photo" do
      get :show, id: 1
      assert_template :show
      assigns(:photo).should == @public_photo
    end

    it "doesn't see an unpublished photo" do
      get :show, id: 2
      response.should redirect_to('/')
      flash[:alert].should == "You are not authorized to access this page."
    end
  end

  context "a normal user" do
    it "still doesn't see an unpublished photo" do
      @private_photo = create(:private_photo, id: 2)
      sign_in create(:user)

      get :show, id: 2
      response.should redirect_to('/')
      flash[:alert].should == "You are not authorized to access this page."
    end
  end

  context "an admin" do
    before do
      @public_photo = create(:public_photo, id: 1)
      @private_photo = create(:private_photo, id: 2)

      sign_in create(:admin)
    end

    it "sees the list of all photos (even unpublished)" do
      get :index
      assert_template :index
      assigns(:photos).should =~ [@public_photo, @private_photo]
    end

    it "sees an unpublished photo" do
      get :show, id: 2
      assert_template :show
      assigns(:photo).should == @private_photo
    end
  end
end
