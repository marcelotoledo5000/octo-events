# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Issue, type: :model do
  context 'with validations' do
    it { is_expected.to validate_presence_of :number }
    it { is_expected.to validate_uniqueness_of(:number) }
  end

  context 'with associations' do
    it { is_expected.to have_many(:webhook_events) }
  end
end
