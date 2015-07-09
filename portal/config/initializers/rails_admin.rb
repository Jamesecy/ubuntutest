RailsAdmin.config do |config|

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method { current_user }

  config.authorize_with :cancan

  config.actions do
    dashboard # mandatory
    index # mandatory
    new
    #import do
    #  only 'Setup::DataType'
    #end
    show
    edit
    delete
    #show_in_app
  end
end
