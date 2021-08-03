class AddUniquenessToNumberOnIssue < ActiveRecord::Migration[6.1]
  def change
    add_index :issues, :number, unique: true
  end
end
