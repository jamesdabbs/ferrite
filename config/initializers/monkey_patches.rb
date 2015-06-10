class ActiveRecord::Relation
  def random
    order("RANDOM()").first
  end
end