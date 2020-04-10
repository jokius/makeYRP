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
  extend Images

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar, dependent: :purge
  images_version :avatar

  has_many :users_in_games, dependent: :destroy
  has_many :games, through: :users_in_games
  has_many :master_in_games, class_name: 'Game', foreign_key: :master_id
  has_many :folders
  has_many :access_levels, dependent: :destroy

  after_create :create_root_folder

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
