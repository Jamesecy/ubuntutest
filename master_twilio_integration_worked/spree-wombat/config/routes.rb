Spree::Core::Engine.add_routes do
  namespace :wombat do
    post '*path', to: 'webhook#consume', as: 'webhook'
  end
end
