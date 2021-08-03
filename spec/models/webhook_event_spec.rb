# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookEvent, type: :model do
  context 'with validations' do
    it { is_expected.to validate_presence_of :data }
    it { is_expected.to validate_presence_of :hook_id }
  end

  context 'with associations' do
    it { is_expected.to belong_to(:issue) }
  end
end
