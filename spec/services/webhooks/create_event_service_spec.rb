# frozen_string_literal: true

require 'rails_helper'

describe Webhooks::CreateEventService, type: :service do
  subject(:create_service) { described_class.new(event_type, github_delivery_id, params) }

  let(:github_delivery_id) { '424242' }
  let(:github_delivery_id2) { '28064212' }
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
    let(:create_second_event) { described_class.new(event_type, github_delivery_id2, params) }
    let(:event_type) { 'issues' }

    it 'returns a success status' do
      expect(create_service.perform).to be_success
    end

    it 'creates a new webhook event on DB' do
      expect { create_service.perform }.to change(WebhookEvent, :count).by(1)
    end

    it 'does not duplicate issue when issue_number already exists' do
      create_service.perform

      expect { create_second_event.perform }.
        to change(WebhookEvent, :count).by(1).
        and change(Issue, :count).by(0)
    end
  end

  context 'with failure' do
    context 'with an unexpected event type' do
      let(:event_type) { 'pull-request' }

      it 'doesnt return failure' do
        expect(create_service.perform).to be_nil
      end

      it 'doesnt create a new event on db' do
        expect { create_service.perform }.not_to change(WebhookEvent, :count)
      end
    end

    context 'with empty params' do
      let(:event_type) { 'issues' }
      let(:params) { '' }

      it 'is expected to return a failure' do
        expect(create_service.perform).not_to be_success
      end

      it 'is expected to return errors messages' do
        expect(create_service.perform.errors).to include("Data can't be blank")
      end

      it 'is expected to log errors' do
        errors = "[\"Issue must exist\", \"Data can't be blank\"]"
        error_msg = "Can't create webhook event. type: issues. params:#{params}. Errors: #{errors}"

        expect(Rails.logger).to receive(:info).with(error_msg)

        create_service.perform
      end
    end
  end
end
