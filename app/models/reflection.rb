class Reflection
  # TODO: adamantium, validate week in 1-12
  attr_reader :course, :week, :topic

  def initialize course, week, topic
    @course, @week, @topic = course, week, topic
    freeze
  end
end
