# frozen_string_literal: true

require 'rails_helper'

describe Webhooks::EventHandlerService, type: :service do
  subject(:execute_service) { described_class.new(request, params).execute }

  let(:event_type) { 'issues' }
  let(:hook_id) { '4242' }
  let(:request) do
    OpenStruct.new(
      {
        env: {
          'HTTP_X_GITHUB_EVENT'   => event_type,
          'HTTP_X_GITHUB_HOOK_ID' => hook_id
        }
      }
    )
  end

  let(:params) do
    {
      action: 'edited',
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
        number: 2,
        assignee: nil,
        comments: 0
      },
      sender: {
        id: 1,
        url: 'https://api.github.com/users/ThawanFidelis',
        type: 'User',
        login: 'ThawanFidelis'
      }
    }
  end

  context 'with success' do
    it 'returns a success status' do
      expect(execute_service).to be_success
    end

    it 'Enqueue a WebhookCreateJob' do
      expect(WebhookCreateJob).to receive(:perform_now).with(event_type, hook_id, params)

      execute_service
    end
  end

  context 'with failure' do
    context 'without github headers on request' do
      let(:request) do
        OpenStruct.new(
          {
            env: {}
          }
        )
      end

      it 'returns a error' do
        expect(execute_service).not_to be_success
      end

      it 'is expected to log errors' do
        error_msg = "Can't proccess webhook. type: undefined. params:#{params}. Errors: Webhook type is not accepted"
        expect(Rails.logger).to receive(:info).
          with(error_msg)

        execute_service
      end
    end
  end
end
