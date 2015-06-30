class AddTeamworkDataToEmployments < ActiveRecord::Migration
  def change
    add_column :employments, :teamwork_data, :json, default: {}
    remove_column :employments, :teamwork_id, :string
  end
end
