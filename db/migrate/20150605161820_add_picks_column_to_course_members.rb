class AddPicksColumnToCourseMembers < ActiveRecord::Migration
  def change
    add_column :course_members, :picks, :integer, default: 0
  end
end
