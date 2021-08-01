# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilterIssueEventsByNumberQuery do
  subject(:events_filter_query) { described_class.new(query_issue_number).perform }

  let(:issue_params) do
    {
      event: {
        issue: {
          number: issue_number
        }
      }
    }
  end

  let(:webhook_event) { WebhookEvent.create(data: issue_params) }

  before do
    webhook_event
  end

  context 'with success' do
    let(:issue_number) { 10 }
    let(:query_issue_number) { 10 }

    it 'returns webhook events based on number' do
      issue_event = WebhookEvent.first

      expect(events_filter_query.response).to include(issue_event)
    end

    it 'returns only data fields from events found' do
      expect(events_filter_query.data_fields).to eq(WebhookEvent.pluck(:data))
    end
  end

  context 'with failure' do
    let(:issue_number) { 10 }
    let(:query_issue_number) { 20 }

    it 'returns an empty array when no event was found' do
      expect(events_filter_query.response).to eq([])
    end

    it 'returns an empty array for data_fields when no event was found' do
      expect(events_filter_query.data_fields).to eq([])
    end
  end

  context 'with nil value' do
    let(:issue_number) { 10 }
    let(:query_issue_number) { nil }

    it 'returns an empty array when no issue_number was passed' do
      expect(events_filter_query.response).to eq([])
    end

    it 'returns an empty array for data_fields when no issue_number was passed' do
      expect(events_filter_query.data_fields).to eq([])
    end
  end
end