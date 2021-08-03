# frozen_string_literal: true

module Webhooks
  class CreateEventService
    def initialize(event_type, github_delivery_id, params)
      @event_type = event_type.to_sym
      @github_delivery_id = github_delivery_id
      @params = params
    end

    def perform
      return unless WebhookEvent::ACCEPTABLE_TYPES.include?(event_type)
      return if webhook_already_created

      webhook_event = WebhookEvent.new(
        issue: issue,
        github_delivery_id: github_delivery_id,
        data: JSON.parse(params.to_json)
      )

      return handle_failure(webhook_event) unless webhook_event.save

      OpenStruct.new({ success?: true, event: webhook_event })
    end

    private

    attr_reader :event_type, :github_delivery_id, :params

    def webhook_already_created
      WebhookEvent.find_by(github_delivery_id: github_delivery_id)
    end

    def issue
      return unless issue_number

      Issue.where(number: issue_number).first_or_initialize
    end

    def issue_number
      return unless params.is_a?(Hash)

      params.dig(:issue, :number)
    end

    def handle_failure(webhook_event)
      errors = webhook_event.errors.full_messages

      Rails.logger.
        info("Can't create webhook event. type: #{event_type}. params:#{params}. Errors: #{errors}")

      OpenStruct.new(
        {
          success?: false,
          event: webhook_event,
          errors: errors
        }
      )
    end
  end
end
