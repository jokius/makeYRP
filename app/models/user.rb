# frozen_string_literal: true

class User
  include Mongoid::Document
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  field :nickname, type: String, default: ''

  ## Database authenticatable
  field :email,              type: String, default: ''
  field :encrypted_password, type: String, default: ''

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  field :admin, type: Boolean, default: false

  include Mongoid::Timestamps
end
