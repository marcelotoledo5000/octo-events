# frozen_string_literal: true

module Webhooks
  module V1
    class EventsController < Webhooks::V1::ApplicationController
      def create
        Webhooks::EventHandlerService.new(request, permitted_params).execute
        render json: {}, status: :accepted
      end

      private

      def permitted_params
        params.permit!.to_h
      end
    end
  end
end
