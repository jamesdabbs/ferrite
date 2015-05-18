module ApplicationHelper
  def choices collection, display_attr, key_attr=:id
    collection.map { |obj| [obj.public_send(display_attr), obj.public_send(key_attr)] }
  end

  def short_date d
    d.strftime "%b '%y"
  end

  def time_to_now dt
    return "" unless dt
    date      = dt.strftime "%b %d @ %l%P"
    distance  = time_ago_in_words dt
    direction = Time.now < dt ? "from now" : "ago"
    "#{date} <small><i>(#{distance} #{direction})</i></small>".html_safe
  end

  def markdown str
    $markdown.render(str).html_safe
  end
end
