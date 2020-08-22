# frozen_string_literal: true

class ResourceQuestion < ApplicationRecord
  belongs_to :question
  belongs_to :resource
end
