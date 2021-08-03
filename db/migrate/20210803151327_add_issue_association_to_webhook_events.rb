class AddIssueAssociationToWebhookEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :webhook_events, :issue, null: false, foreign_key: true
  end
end
