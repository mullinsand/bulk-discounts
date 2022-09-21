require 'teammate'
require 'repo_name'
require 'pull_request'

class GithubService
  def self.get_data(uri_add_on)
    uri = "https://api.github.com/repos/cece-132/little-esty-shop/#{uri_add_on}"
    response = HTTParty.get(uri)
    body = response.body
    parsed = JSON.parse(body, symbolize_names: true)
  end
end

