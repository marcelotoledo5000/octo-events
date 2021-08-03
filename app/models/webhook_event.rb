# frozen_string_literal: true

class WebhookEvent < ApplicationRecord
  ACCEPTABLE_TYPES = %i[issues].freeze

  belongs_to :issue

  validates :data, :hook_id, presence: true
end
