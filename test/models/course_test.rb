require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  def test_it_enumerates_weeks
    course = Course.new
    assert_equal   course.weeks.count, 12
    assert_kind_of Week, course.weeks.first
    assert_equal   course.weeks.first.course, course
  end

  def test_it_increments_picks_when_student_has_been_picked
    @course = courses "DC-RoR"
    first_student_picked = @course.pick_member
    first_pick = CourseMember.where(course_id: @course.id, user_id: first_student_picked.id).first
    assert_equal first_pick.picks, 1
    
    second_student_picked = @course.pick_member
    second_pick = CourseMember.where(course_id: @course.id, user_id: second_student_picked.id).first
    assert_equal second_pick.picks, 1
    
    refute_equal first_pick, second_pick
    users_who_got_picked = CourseMember.where(course_id: @course.id, picks: 1)
    assert_equal users_who_got_picked.count, 2
  end

  def test_it_picks_someone_who_hasnt_been_picked
    # student with fewer picks gets picked.
    # student
  end
end
