module ApplicationHelper
  def choices collection, display_attr, key_attr=:id
    collection.map { |obj| [obj.public_send(display_attr), obj.public_send(key_attr)] }
  end

  def short_date d
    d.strftime "%b '%y"
  end

  def markdown str
    $markdown.render(str).html_safe
  end
end
