# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookEvent, type: :model do
  context 'with validations' do
    it { is_expected.to validate_presence_of :data }
  end
end
