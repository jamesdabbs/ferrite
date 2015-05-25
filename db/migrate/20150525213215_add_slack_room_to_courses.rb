class AddSlackRoomToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :slack_room, :string
  end
end
