class User < ActiveRecord::Base
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

  validates_confirmation_of :password
  validates_presence_of :first_name, :last_name, :username, :password, :age, :gender, :status
  #validates_numercality_of :age
  #validates_uniqueness_of :username

  wizardly_page :init, :fields=>[:first_name, :last_name]
  wizardly_page :second, :fields=>[:age, :gender, :programmer, :status]
  wizardly_page :finish, :fields=>[:username, :password, :password_confirmation]

end
