require 'spec_helper'

describe PostsController do
  fixtures :posts

  context "an anon user" do
    let(:public_post) { posts(:public) }

    it "sees the list of published posts" do
      get :index
      assert_template :index
      assigns(:posts).should == [public_post]
    end

    it "sees a published post" do
      get :show, id: 'a-public-post'
      assert_template :show
      assigns(:post).should == public_post
    end

    it "doesn't see an unpublished post" do
      get :show, id: 'a-private-post'
      response.should redirect_to('/')
      flash[:alert].should == "You are not authorized to access this page."
    end
  end

  context "a normal user" do
    it "still doesn't see an unpublished post" do
      sign_in create(:user)
      get :show, id: 'a-private-post'
      response.should redirect_to('/')
      flash[:alert].should == "You are not authorized to access this page."
    end
  end

  context "an admin" do
    it "sees an unpublished post" do
      sign_in create(:admin)
      get :show, id: 'a-private-post'
      assert_template :show
    end
  end
end
