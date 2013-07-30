class Post < ActiveRecord::Base

  rails_admin do
    edit do
      field :content, :ck_editor
    end
  end

end
