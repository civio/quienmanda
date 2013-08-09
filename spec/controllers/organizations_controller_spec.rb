require 'spec_helper'

describe OrganizationsController do
  before do
    @public_organization = create(:public_organization)
    @private_organization = create(:private_organization)
  end

  context "an anon user" do
    it "sees the list of published organizations" do
      get :index
      assert_template :index
      assigns(:organizations).should == [@public_organization]
    end

    it "sees a published organization" do
      get :show, id: 'a-public-organization'
      assert_template :show
      assigns(:organization).should == @public_organization
    end

    it "doesn't see an unpublished organization" do
      get :show, id: 'a-private-organization'
      response.should redirect_to('/')
      flash[:alert].should == "You are not authorized to access this page."
    end
  end

  context "a normal user" do
    it "still doesn't see an unpublished organization" do
      sign_in create(:user)
      get :show, id: 'a-private-organization'
      response.should redirect_to('/')
      flash[:alert].should == "You are not authorized to access this page."
    end
  end

  context "an admin" do
    before do
      sign_in create(:admin)
    end

    it "sees the list of all organizations (even unpublished)" do
      get :index
      assert_template :index
      assigns(:organizations).should =~ [@public_organization, @private_organization]
    end

    it "sees an unpublished organization" do
      get :show, id: 'a-private-organization'
      assert_template :show
      assigns(:organization).should == @private_organization
    end
  end
end
