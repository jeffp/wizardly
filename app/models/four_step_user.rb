class FourStepUser < User
  
  validation_group :init, :fields=>[:first_name, :last_name]
  validation_group :second, :fields=>[:age, :gender]
  validation_group :third, :fields=>[:programmer, :status]
  validation_group :finish, :fields=>[:username, :password, :password_confirmation]
  
  
end