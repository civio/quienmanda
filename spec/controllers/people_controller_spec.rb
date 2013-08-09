require 'spec_helper'

describe PeopleController do
  before do
    @public_person = create(:public_person)
    @private_person = create(:private_person)

    @public_relation = create(:relation, source: @public_person, target: @private_person, published: true)
    @private_relation = create(:relation, source: @public_person, target: @private_person, published: false)
  end

  context "an anon user" do
    it "sees the list of published people" do
      get :index
      assert_template :index
      assigns(:people).should == [@public_person]
    end

    it "sees a published person" do
      get :show, id: 'a-public-person'
      assert_template :show
      assigns(:person).should == @public_person
    end

    it "sees only the published relations for a given person" do
      get :show, id: 'a-public-person'
      assigns(:relations).should == [@public_relation]
    end

    it "doesn't see an unpublished person" do
      get :show, id: 'a-private-person'
      response.should redirect_to('/')
      flash[:alert].should == "You are not authorized to access this page."
    end
  end

  context "a normal user" do
    it "still doesn't see an unpublished person" do
      sign_in create(:user)
      get :show, id: 'a-private-person'
      response.should redirect_to('/')
      flash[:alert].should == "You are not authorized to access this page."
    end
  end

  context "an admin" do
    before do
      sign_in create(:admin)
    end

    it "sees the list of all people (even unpublished)" do
      get :index
      assert_template :index
      assigns(:people).should =~ [@public_person, @private_person]
    end

    it "sees an unpublished person" do
      get :show, id: 'a-private-person'
      assert_template :show
      assigns(:person).should == @private_person
    end

    it "sees all the relations for a given person" do
      get :show, id: 'a-public-person'
      assigns(:relations).should =~ [@public_relation, @private_relation]
    end
  end
end
