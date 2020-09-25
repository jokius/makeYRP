# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  color                  :string           not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  jti                    :string           not null
#  nickname               :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  extend Images

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_one_attached :avatar, dependent: :purge
  images_version :avatar

  has_many :users_in_games, dependent: :destroy
  has_many :games, through: :users_in_games
  has_many :master_in_games, class_name: 'Game', foreign_key: :master_id
  has_many :folders, dependent: :destroy
  has_many :access_levels, dependent: :destroy

  before_create :create_color
  after_create :create_root_folder

  def create_color
    color = "##{SecureRandom.hex(3)}"
    self.color = color
  end

  def create_root_folder
    folders.create(name: 'Корневая папка')
  end

  def avatars
    avatar.attached? ? image_avatars : gravatar_avatars
  end

  def master?(game)
    master_in_games.exists?(game.id)
  end

  private

  def image_avatars
    {
      url: avatar_url,
      lazy: avatar_lazy,
      thumb: avatar_thumb,
      chat: avatar_chat
    }
  end

  def gravatar_avatars
    hash = Digest::MD5.hexdigest(email)
    url = "https://www.gravatar.com/avatar/#{hash}"
    {
      url: url,
      thumb: url + "?s=#{Images::THUMB}",
      chat: url + "?s=#{Images::CHAT}",
      lazy: url + "?s=#{Images::LAZY}"
    }
  end
end
