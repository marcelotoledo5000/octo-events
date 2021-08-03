# frozen_string_literal: true

require 'rails_helper'

describe 'Create webhooks', type: :request do
  subject(:run_request) do
    post(
      '/webhooks/v1/events',
      params: request_params,
      headers: request_headers
    )
  end

  let(:request_headers) do
    {
      'X-Hub-Signature-256'   => secret_token,
      'HTTP_X_GITHUB_EVENT'   => 'issues',
      'HTTP_X_GITHUB_DELIVERY' => '424242'
    }
  end
  let(:request_params) { { action: 'create' }.to_json }
  let(:formated_response) { JSON.parse(response.body) }

  context 'when request isnt authenticated' do
    let(:secret_token) { '' }

    it 'returns a failure response to unauthorized' do
      run_request

      expect(response).to have_http_status :unauthorized
      expect(formated_response['errors']).to include('invalid Webhook secret token')
    end
  end

  context 'when request is authenticated' do
    let(:secret_token) do
      sha256_token = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV['SECRET_TOKEN'], request_params)
      "sha256=#{sha256_token}"
    end

    it 'returns a success response' do
      run_request

      expect(response).to have_http_status :accepted
    end
  end
end
