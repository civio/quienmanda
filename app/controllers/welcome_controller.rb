class WelcomeController < ApplicationController
  def index
    # Show the latest three articles in the frontpage
    @frontpage = Post.where("photo is not null").order("updated_at desc").limit(3)
    @frontpage = @frontpage.published() unless can? :manage, Post
  end
end
