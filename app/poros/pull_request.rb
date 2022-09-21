class PullRequest
  attr_reader :id

  def initialize(data)
    @id = data[:id]
  end
end