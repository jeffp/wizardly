class UserAvatar < User

  has_attached_file :avatar
  validates_attachment_presence :avatar

  validation_group :init, :fields=>[:first_name, :last_name]
  validation_group :second, :fields=>[:age, :gender, :programmer, :status, :avatar]
  validation_group :finish, :fields=>[:username, :password, :password_confirmation]

end
