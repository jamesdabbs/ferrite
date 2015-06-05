class AddPicksColumntoUSersTable < ActiveRecord::Migration
  def change
    add_column :users, :picks, :integer, default: 0
  end
end
