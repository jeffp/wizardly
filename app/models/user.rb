require 'validation_group'
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

  validation_group :init, :fields=>[:first_name, :last_name]
  validation_group :second, :fields=>[:age, :gender, :programmer, :status]
  validation_group :finish, :fields=>[:username, :password, :password_confirmation]

end
