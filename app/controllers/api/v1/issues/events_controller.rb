# frozen_string_literal: true

module Api
  module V1
    module Issues
      class EventsController < Api::V1::ApplicationController
        def index
          events = FilterIssueEventsByNumberQuery.new(params[:issue_number]).perform

          if events.response.any?
            render json: events.data_fields
          else
            render json: { status: :not_found }, status: :not_found
          end
        end
      end
    end
  end
end
