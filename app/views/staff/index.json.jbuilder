json.staff @staff do |e|
  json.(e, :first_name, :last_name, :campus, :current_course, :title, :slack_username, :phone_number, :skype_username)
  json.avatar_url e.slack_avatar(24)
end
