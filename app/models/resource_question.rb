# frozen_string_literal: true
# typed: strict

class ResourceQuestion < ApplicationRecord
  belongs_to :question
  belongs_to :resource
end
