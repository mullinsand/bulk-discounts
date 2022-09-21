class GithubService
  def self.get_github_data
    repo_name = get_repo_name_data()
    commit_hash = get_repo_commits_data()
    collaborators = get_collaborators_data()
    pull_requests_amt = get_pull_requests_data()
  end

  def self.get_uri(url)
    body = response.body
    parsed = JSON.parse(body, symbolize_names: true)
  end
end