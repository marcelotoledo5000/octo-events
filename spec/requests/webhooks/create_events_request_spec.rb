# frozen_string_literal: true

require 'rails_helper'

describe 'Create webhook event', type: :request do
  subject(:run_request) do
    post(
      '/webhooks/v1/events',
      params: request_params,
      headers: request_headers
    )
  end

  let(:request_headers) do
    {
      'Content-type'          => Mime[:json].to_s,
      'X-Hub-Signature-256'   => secret_token,
      'HTTP_X_GITHUB_EVENT'   => 'issues',
      'HTTP_X_GITHUB_HOOK_ID' => '424242'
    }
  end

  let(:request_params) do
    {
      action: 'create',
      issue: {
        number: 42
      }
    }.to_json
  end

  let(:formated_response) { JSON.parse(response.body) }

  context 'with success' do
    let(:secret_token) do
      sha256_token = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV['SECRET_TOKEN'], request_params)
      "sha256=#{sha256_token}"
    end

    it 'returns a success response' do
      run_request

      expect(response).to have_http_status :accepted
    end

    it 'creates a new webhook event on DB' do
      expect { run_request }.to change(WebhookEvent, :count).by(1)
    end
  end
end
