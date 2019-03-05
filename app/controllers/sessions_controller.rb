class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def create
    # Step 2 Using code from Github after users has authenticated,
    # send a post request back to github with your client credientials and the code
    # If successful, Github will send back a response with an access token
    client_id = ENV['GITHUB_CLIENT_ID']
    client_secret = ENV['GITHUB_CLIENT_SECRET']
    code = params['code']

    response = Faraday.post "https://github.com/login/oauth/access_token" do |req|
      req.body = { 'client_id': client_id, 'client_secret': client_secret, 'code': params['code'] }
      req.headers['Accept'] = 'application/json'
    end

    #Step 3 Upon success, save the token to the session and use it for accessing github api
    body = JSON.parse(response.body)
    session[:token] = body['access_token']

    redirect_to root_path
  end
end
