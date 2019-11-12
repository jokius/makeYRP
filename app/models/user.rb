# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  nickname               :string           not null
#  admin                  :boolean          default(FALSE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  has_many :users_in_games, dependent: :destroy
  has_many :games, through: :users_in_games
  has_many :master_in_games, class_name: 'Game', foreign_key: :master_id
  has_many :folders

  after_create :create_root_folder

  def create_root_folder
    folders.create(name: 'Корневая папка')
  end
end
