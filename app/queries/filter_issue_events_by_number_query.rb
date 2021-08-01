# frozen_string_literal: true

class FilterIssueEventsByNumberQuery
  attr_reader :issue_number

  def initialize(issue_number)
    @issue_number = issue_number
  end

  def perform
    OpenStruct.new({ response: webhook_events, data_fields: webhook_events.pluck(:data) })
  end

  private

  def webhook_events
    @webhook_events ||=
      WebhookEvent.where('data @> ?', {
        event: {
          issue: {
            number: issue_number&.to_i
          }
        }
      }.to_json)
  end
end
