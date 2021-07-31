# frozen_string_literal: true

module Webhooks
  module V1
    class EventsController < Webhooks::V1::ApplicationController
      def create
        render json: {}, status: :ok
      end
    end
  end
end
