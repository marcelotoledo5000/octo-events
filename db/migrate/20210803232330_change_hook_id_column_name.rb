class ChangeHookIdColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :webhook_events, :hook_id, :github_delivery_id
  end
end
