class Week
  attr_reader :course, :number, :summary

  def initialize course, number
    @course, @number = course, number
    @data    = @course.reflections[number] || {}
    @summary = @data["summary"]            || ""
    freeze
  end

  def reflections
    Reflection.types.map do |ref_type|
      fail
    end
  end
end
