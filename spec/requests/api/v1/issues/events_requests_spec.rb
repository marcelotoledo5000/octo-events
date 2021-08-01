# frozen_string_literal: true

require 'rails_helper'

describe 'Get issue events', type: :request do
  subject(:run_request) do
    get(
      "/api/v1/issues/#{query_issue_number}/events",
      headers: request_headers
    )
  end

  let(:request_headers) do
    {
      'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.
        encode_credentials(ENV['API_TOKEN'])
    }
  end

  let(:issue_number) { 2 }
  let(:query_issue_number) { 2 }
  let(:issue_params) do
    {
      event: {
        issue: {
          id: 1,
          url: 'https://api.github.com/repos/xxxx/xxxx/issues/1',
          body: '',
          user: {
            id: '599456',
            url: 'https://api.github.com/users/ThawanFidelis'
          },
          state: 'open',
          title: 'ISSUE EDITADA',
          labels: [],
          number: issue_number,
          assignee: nil,
          comments: 0
        },
        action: 'edited',
        sender: {
          id: 1,
          url: 'https://api.github.com/users/ThawanFidelis',
          type: 'User',
          login: 'ThawanFidelis'
        }
      }
    }
  end

  let(:webhook_event) do
    WebhookEvent.create(data: issue_params)
  end

  let(:response_data) { JSON.parse(response.body) }

  before do
    webhook_event
  end

  context 'with success' do
    it 'returns a success status' do
      run_request

      expect(response).to have_http_status :ok
    end

    it 'returns an issue events' do
      run_request

      expect(response_data).to eq([JSON.parse(issue_params.to_json)])
    end
  end

  context 'with failure' do
    let(:query_issue_number) { 42 }

    it 'returns a not_found status when issue does not exists' do
      run_request

      expect(response).to have_http_status :not_found
    end
  end

  context 'with an unauthorized request' do
    let(:request_headers) { {} }

    it 'returns a not authorized status' do
      run_request

      expect(response).to have_http_status :unauthorized
    end
  end
end
