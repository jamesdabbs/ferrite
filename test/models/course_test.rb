require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  def test_it_enumerates_weeks
    course = Course.new
    assert_equal   course.weeks.count, 12
    assert_kind_of Week, course.weeks.first
    assert_equal   course.weeks.first.course, course
  end
end
