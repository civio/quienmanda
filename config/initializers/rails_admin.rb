# RailsAdmin config file. Generated on July 29, 2013 23:52
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|


  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['QuienManda', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_user } # auto-generated

  # Authorization via CanCan
  RailsAdmin.config do |config|
    config.authorize_with :cancan
  end

  # Extra actions:
  #  - toggle: to toggle booleans from index view, see rails_admin_toggleable
  config.actions do
    dashboard
    index
    new
    history_index
    show
    edit
    delete
    history_show
    toggle
    show_in_app
  end

  # Add our own custom admin stuff
  config.navigation_static_label = "Extra Admin"
  config.navigation_static_links = {
    'Import' => '/admin/import'
  }

  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  # config.excluded_models = ['Entity', 'User']

  # Include specific models (exclude the others):
  # config.included_models = ['Entity', 'User']

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.


  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
  # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:


  config.model 'Entity' do
    list do
      field :published, :toggle
      field :needs_work
      field :priority
      field :person
      field :name
      field :short_name
      field :description
    end

    edit do
      group :basic_info do
        label "Basic info"
        field :person do
          default_value true
        end
        field :name
        field :short_name
        field :description
        field :priority do
          default_value Entity::PRIORITY_MEDIUM
        end
        field :avatar
      end
      group :social_media do
        label "Social media / web"
        field :web_page
        field :twitter_handle
        field :wikipedia_page
        field :facebook_page
        field :open_corporates_page
        field :flickr_page
        field :youtube_page
        field :linkedin_page
      end
      group :relations do
        # Editing the relations through the default RailsAdmin control (moving across
        # two columns) is very confusing. So disable for now.
        field :relations_as_source do
          read_only true
          inverse_of :source
        end
        field :relations_as_target do
          read_only true
          inverse_of :target
        end
        field :related_photos do
          read_only true
          inverse_of :related_entities
        end
      end
      group :internal do
        label "Internal"
        field :published do
          default_value false
        end
        field :needs_work do
          default_value true
        end
        field :slug do
          help 'Leave blank for the URL slug to be auto-generated'
        end
        field :notes
      end
    end

    object_label_method do
      :short_or_long_name
    end
  end

  config.model 'Fact' do
    list do
      field :importer
      field :relations
      field :summary
    end

    edit do
      field :importer
      field :relations do
        read_only true
      end
      field :summary do
        read_only true
      end
    end
  end  

  config.model 'Photo' do
    list do
      field :published, :toggle
      field :needs_work
      field :file
      field :footer
      field :tag_list
    end

    edit do
      group :basic_info do
        label "Content"
        field :file
        field :footer
        field :copyright
        field :source
        field :date do
          strftime_format "%d/%m/%Y"
        end
      end
      group :relations do
        field :related_entities
      end
      group :internal do
        field :extra_wide do
          default_value false
        end
        field :published do
          default_value false
        end
        field :needs_work do
          default_value true
        end
        field :tag_list do
          label "Tags"
          partial 'tag_list_with_suggestions'
        end
        field :notes
      end
    end
  end

  # RailsAdmin configuration
  config.model 'Post' do
    list do
      field :published, :toggle
      field :needs_work
      field :title
      field :author
    end

    edit do
      group :basic_info do
        label "Content"
        field :title
        field :lead
        field :content, :ck_editor do 
          help 'Puedes insertar códigos como: [dc url="..."] [qm url="..." text="..."] [gdocs url="..."]'
        end
        field :author do
          inverse_of :posts
        end
      end
      group :internal do
        label "Internal"
        field :photo
        field :show_photo_as_header do
          default_value false
        end
        field :published do
          default_value false
        end
        field :needs_work do
          default_value true
        end
        field :slug do
          help 'Leave blank for the URL slug to be auto-generated'
        end
        field :notes
      end
    end
  end

  config.model 'Relation' do
    list do
      field :published, :toggle
      field :needs_work
      field :source
      field :relation_type
      field :target
      field :via
    end

    edit do
      group :basic_info do
        field :source
        field :relation_type
        field :target
        field :via
        field :via2
        field :via3
      end
      group :timeline do
        field :from do
          strftime_format "%d/%m/%Y"
        end
        field :to do
          strftime_format "%d/%m/%Y"
        end
        field :at do
          strftime_format "%d/%m/%Y"
        end
      end
      group :internal do
        field :published do
          default_value true
        end
        field :needs_work do
          default_value false
        end
        field :facts do
          read_only true
        end
        field :notes
      end
    end

    object_label_method do
      :to_s
    end
  end

  config.model 'RelationType' do
    parent Relation

    list do
      field :description
    end

    edit do
      field :description
      field :relations do
        read_only true
      end
    end

    object_label_method do
      :description
    end
  end

  config.model 'User' do  
    object_label_method :name
  end

  ###  User  ###

  # config.model 'User' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your user.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :id, :integer 
  #     configure :email, :string 
  #     configure :password, :password         # Hidden 
  #     configure :password_confirmation, :password         # Hidden 
  #     configure :reset_password_token, :string         # Hidden 
  #     configure :reset_password_sent_at, :datetime 
  #     configure :remember_created_at, :datetime 
  #     configure :sign_in_count, :integer 
  #     configure :current_sign_in_at, :datetime 
  #     configure :last_sign_in_at, :datetime 
  #     configure :current_sign_in_ip, :string 
  #     configure :last_sign_in_ip, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end

end
