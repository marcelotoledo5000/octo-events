# frozen_string_literal: true

class Issue < ApplicationRecord
  has_many :webhook_events, dependent: :destroy

  validates :number, presence: true, uniqueness: true
end
