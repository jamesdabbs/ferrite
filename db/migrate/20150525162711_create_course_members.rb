class CreateCourseMembers < ActiveRecord::Migration
  def change
    create_table :course_members do |t|
      t.belongs_to :course, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.string :role, null: false
    end
  end
end
