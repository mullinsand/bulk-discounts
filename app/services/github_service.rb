require 'teammate'
require 'repo_name'
require 'pull_request'

class GithubService
  def self.get_github_data
    github_data = Hash.new
    github_data[:repo_name] = get_repo_name_data
    github_data[:teammates] = get_teammate_data
    github_data[:pull_request_count] = get_pull_request_data
    github_data
  end

  def self.get_repo_name_data
    response = HTTParty.get("https://api.github.com/repos/cece-132/little-esty-shop")
    parsed = JSON.parse(response.body, symbolize_names: true)
    parsed[:name]
  end


  def self.get_teammate_data
    response = HTTParty.get("https://api.github.com/repos/cece-132/little-esty-shop/contributors")
    parsed = JSON.parse(response.body, symbolize_names: true)
    teammates = parsed.map do |teammate_data|
      Teammate.new(teammate_data)
    end
    our_teammates = [teammates[0], teammates[1], teammates[2], teammates[4]]
  end

  def self.get_pull_request_data
    response = HTTParty.get("https://api.github.com/repos/cece-132/little-esty-shop/pulls?state=all")
    parsed = JSON.parse(response.body, symbolize_names: true)
    parsed.map do |pr_data|
      PullRequest.new(pr_data)
    end.size
  end




  def self.get_uri(uri)
    uri = "https://api.github.com/repos/cece-132/little-esty-shop"
    response = HTTParty.get(uri)
    body = response.body
    parsed = JSON.parse(body, symbolize_names: true)
  end
end

