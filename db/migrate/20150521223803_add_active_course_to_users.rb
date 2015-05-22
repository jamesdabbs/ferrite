class AddActiveCourseToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active_course_id, :integer
  end
end
