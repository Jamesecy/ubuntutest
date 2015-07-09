module ApplicationHelper
  
  def generate_url(url, params = {})
     uri = URI(url)
     uri.query = params.to_query
     uri.to_s
  end

  def cenitodoo_url(user, odoo_app)
    access_token = Doorkeeper::AccessToken.create!(
      application_id: odoo_app.uid,
      resource_owner_id: user.id,
      scopes: 'userinfo',
      expires_in: 7200
    )
    params = {
      access_token: access_token.token,
      token_type: 'bearer',
      expires_in: 7200,
      state: {
        login: user.email
      }.to_json
    }
    redirect_url = odoo_app.redirect_uri.split.first
    generate_url(redirect_url, params)
  end
  
  def cenithub_url(cenit_app)
    params = { 
      client_id: cenit_app.uid, 
      redirect_uri: cenit_app.redirect_uri.split.first, 
      response_type: 'code'
    }
    generate_url("/oauth/authorize", params)
  end
end
