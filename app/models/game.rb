# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  system_id  :bigint           not null
#  master_id  :bigint           not null
#  name       :string           not null
#  open       :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Game < ApplicationRecord
  belongs_to :system
  belongs_to :master, class_name: 'User'
  has_one :custom_system, dependent: :destroy

  has_many :users_in_games, dependent: :destroy
  has_many :users, through: :users_in_games
  has_many :pages
  has_many :menus
  has_many :messages

  accepts_nested_attributes_for :custom_system

  after_create :add_custom_system

  def limit_messages(limit)
    messages.order(created_at: :desc).limit(limit).reverse
  end

  def template
    hash = system.template['template']
    custom_system.template.each do |key, value|
      hash = deep_or_merge(key, value, hash)
    end

    hash
  end

  def add_custom_system
    create_custom_system
  end

  private

  def deep_or_merge(key, value, hash)
    if value.is_a? Hash
      value.each { |d_key, d_value| hash[key] = deep_or_merge(d_key, d_value, hash[key]) }
    elsif value.is_a? Array
      hash[key] = value.concat(Array.wrap(hash[key])).uniq
    else
      hash[key] = value
    end

    hash
  end
end
