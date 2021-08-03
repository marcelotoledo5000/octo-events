class CreateIssues < ActiveRecord::Migration[6.1]
  def change
    create_table :issues do |t|
      t.integer :number

      t.timestamps
    end
  end
end
