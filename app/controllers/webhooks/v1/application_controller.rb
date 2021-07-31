# frozen_string_literal: true

module Webhooks
  module V1
    class ApplicationController < ActionController::Base
      before_action :validate_signature

      private

      def validate_signature
        data = { errors: ['invalid Webhook secret token'] }

        render json: data, status: :unauthorized unless valid_signature?
      end

      def valid_signature?
        # reference: https://docs.github.com/en/developers/webhooks-and-events/webhooks/securing-your-webhooks#validating-payloads-from-github
        Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE_256'])
      end

      def signature
        return @signature if @signature

        request.body.rewind
        payload_body = request.body.read
        sha256_token = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV['SECRET_TOKEN'], payload_body)
        @signature = "sha256=#{sha256_token}"
      end
    end
  end
end
