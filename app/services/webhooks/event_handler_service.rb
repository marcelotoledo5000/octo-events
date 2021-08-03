# frozen_string_literal: true

module Webhooks
  class EventHandlerService
    def initialize(request, params)
      @event_type = request.env['HTTP_X_GITHUB_EVENT']
      @github_delivery_id = request.env['HTTP_X_GITHUB_DELIVERY']
      @params = params
    end

    def execute
      return failure_for_unacceptable_type unless event_type
      return failure_for_unacceptable_type unless WebhookEvent::ACCEPTABLE_TYPES.include?(event_type.to_sym)

      # TODO: Add sidekiq to process job asynchronously
      WebhookCreateJob.perform_now(event_type, github_delivery_id, params)
      OpenStruct.new({ success?: true })
    end

    private

    attr_reader :github_delivery_id, :event_type, :params

    def failure_for_unacceptable_type
      error = 'Webhook type is not accepted'

      Rails.logger.
        info("Can't proccess webhook. type: #{event_type || 'undefined'}. params:#{params}. Errors: #{error}")

      OpenStruct.new(success?: false, errors: error)
    end
  end
end
