# frozen_string_literal: true

json.extract! authentication, :id, :user_id, :emailtoken, :token, :created_at, :updated_at
json.url authentication_url(authentication, format: :json)
