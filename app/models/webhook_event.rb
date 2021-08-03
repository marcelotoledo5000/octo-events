# frozen_string_literal: true

class WebhookEvent < ApplicationRecord
  belongs_to :issue

  validates :data, :hook_id, presence: true
end
