# frozen_string_literal: true

module Api
  module V1
    module Issues
      class EventsController < Api::V1::ApplicationController
        def index
          events = FilterIssueEventsByNumberQuery.new(issue_number).perform

          if events.response.any?
            render json: events.data_attributes
          else
            render json: { status: :not_found }, status: :not_found
          end
        end

        private

        def issue_number
          params[:issue_number]
        end
      end
    end
  end
end
