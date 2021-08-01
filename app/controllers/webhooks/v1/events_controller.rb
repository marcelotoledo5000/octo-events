# frozen_string_literal: true

module Webhooks
  module V1
    class EventsController < Webhooks::V1::ApplicationController
      def create
        Webhooks::CreateEventService.new(webhook_event_type, params).perform
        render json: {}, status: :ok
      end

      private

      def webhook_event_type
        request.env['HTTP_X_GITHUB_EVENT']
      end
    end
  end
end
