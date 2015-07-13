json.staff @staff do |e|
  json.(e, :id, :email, :first_name, :last_name, :title, :slack_username, :phone_number, :skype_username)
  json.campus e.campus.try(:name)
  json.current_course do
    if course = e.current_course
      json.topic    course.topic.title
      json.start_on course.start_on
    end
  end

  e.avatars.each do |k,v|
    json.set! k,v
  end
end
