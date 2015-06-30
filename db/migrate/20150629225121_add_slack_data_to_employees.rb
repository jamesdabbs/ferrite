class AddSlackDataToEmployees < ActiveRecord::Migration
  def change
    add_column :employments, :slack_data, :json, default: {}
  end
end
