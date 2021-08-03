# frozen_string_literal: true

class WebhookCreateJob < ApplicationJob
  queue_as :webhook_creations

  def perform(event_type, github_delivery_id, payload_body)
    Webhooks::CreateEventService.new(event_type, github_delivery_id, payload_body).perform
  end
end
