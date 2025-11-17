# frozen_string_literal: true

class VersionController < ActionController::API
  def show
    render json: {
      api_version: Rails.application.config.version,
      git_commit: ENV.fetch("GIT_COMMIT", "unknown"),
      git_branch: ENV.fetch("GIT_BRANCH", "unknown"),
      deployed_at: ENV.fetch("DEPLOYED_AT", "unknown")
    }
  end
end
