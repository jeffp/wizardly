#require 'validation_group'
class Subuser < User
  #set_table_name "users"
=begin
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password
      t.integer :age
      t.string :gender
      t.boolean :programmer
      t.string :status
=end


  validation_group :init, :fields=>[:first_name, :last_name]
  validation_group :second, :fields=>[:age, :gender, :programmer, :status]
  validation_group :finish, :fields=>[:username, :password, :password_confirmation]

end
