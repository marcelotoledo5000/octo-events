# frozen_string_literal: true

class FilterIssueEventsByNumberQuery
  def initialize(issue_number)
    @issue_number = issue_number
  end

  def perform
    @issue = Issue.find_by(number: issue_number)
    OpenStruct.new({ issue: @issue, response: webhook_events, data_attributes: data_attribute })
  end

  private

  attr_reader :issue, :issue_number

  def webhook_events
    return [] unless issue

    @webhook_events ||= issue.webhook_events
  end

  def data_attribute
    @data_attribute ||= webhook_events.pluck(:data)
  end
end
