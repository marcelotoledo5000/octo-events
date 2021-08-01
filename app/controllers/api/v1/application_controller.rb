# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :authenticate!

      private

      def authenticate!
        authenticate_with_http_token do |token, _|
          token == ENV['API_TOKEN']
        end || head(:unauthorized)
      end
    end
  end
end
