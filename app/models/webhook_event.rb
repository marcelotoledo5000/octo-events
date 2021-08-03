# frozen_string_literal: true

class WebhookEvent < ApplicationRecord
  ACCEPTABLE_TYPES = %i[issues].freeze

  belongs_to :issue

  validates :data, :github_delivery_id, presence: true
end
