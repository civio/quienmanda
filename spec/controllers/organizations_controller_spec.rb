require 'spec_helper'

describe OrganizationsController do
  before do
    @public_organization = create(:public_organization)
    @private_organization = create(:private_organization)

    @public_relation = create(:relation, source: @public_organization, target: @private_organization, published: true)
    @private_relation = create(:relation, source: @public_organization, target: @private_organization, published: false)
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

    it "sees only the published relations for a given organization" do
      get :show, id: 'a-public-organization'
      assigns(:relations).should == [@public_relation]
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

    it "sees all the relations for a given organization" do
      get :show, id: 'a-public-organization'
      assigns(:relations).should =~ [@public_relation, @private_relation]
    end
  end
end
