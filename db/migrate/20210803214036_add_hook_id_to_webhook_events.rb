class AddHookIdToWebhookEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :webhook_events, :hook_id, :string
  end
end
