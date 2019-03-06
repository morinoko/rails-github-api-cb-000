class RepositoriesController < ApplicationController
  def index
    @username = get_username
    @repos = get_repos
  end

  def create
    repo_name = params[:name]

    response = Faraday.post "https://api.github.com/user/repos" do |req|
      req.body = { 'name': repo_name }.to_json
      req.headers['Authorization'] = "token #{session[:token]}"
      req.headers['Accept'] = 'application/json'
    end

    redirect_to root_path
  end

  private

  def get_username
    login_info = Faraday.get "https://api.github.com/user" do |req|
      req.headers['Authorization'] = "token #{session[:token]}"
      req.headers['Accept'] = 'application/json'
    end

    login_info_body = JSON.parse(login_info.body)
    login_info_body['login']
  end

  def get_repos
    repo_info = Faraday.get "https://api.github.com/user/repos" do |req|
      req.body = { 'sort': 'created', 'direction': 'asc' }
      req.headers['Authorization'] = "token #{session[:token]}"
      req.headers['Accept'] = 'application/json'
    end

    repo_info_body = JSON.parse(repo_info.body)
  end

end
