# frozen_string_literal: true

class WebhookEvent < ApplicationRecord
  validates :data, presence: true
end
