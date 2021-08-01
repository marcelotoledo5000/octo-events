# frozen_string_literal: true

module Webhooks
  class CreateEventService
    attr_reader :event_type, :params

    def initialize(event_type, params)
      @event_type = event_type
      @params = params
    end

    def perform
      return unless issue_event?

      event = WebhookEvent.new(data: params)

      if event.save
        OpenStruct.new({ success?: true, event: event })
      else
        handle_failure(event)
      end
    end

    private

    def handle_failure(event)
      Rails.logger.
        info("Can't proccess webhook. type: #{event_type}. params:#{params}. Errors: #{event.errors.full_messages}")

      OpenStruct.new(
        {
          success?: false,
          event: event,
          errors: event.errors.full_messages
        }
      )
    end

    def issue_event?
      event_type == 'issues'
    end
  end
end
