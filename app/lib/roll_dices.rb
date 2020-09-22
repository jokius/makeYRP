# frozen_string_literal: true

class RollDices
  DICES_REGX = /([lh]?)(\d*)D(\d*)((?:[+-]\d*)?)/i.freeze

  def call!(raw_roll, game_id)
    template = Game.find(game_id).system.template['template']
    case raw_roll
    when Hash
      by_hash(raw_roll, template)
    when String
      by_string(raw_roll)
    else
      raise('incorrect format')
    end
  end

  private

  def by_hash(raw_roll, template)
    raw_roll.each_with_object({}) do |(key, value), result|
      dice = dice_by_template(key, template['dices'] || [])
      face = dice.split(/d/)[1].to_i

      result[key] = roll(value, face)
    end
  end

  def by_string(raw_roll)
    DICES_REGX =~ raw_roll
    mod = Regexp.last_match(1)
    count = Regexp.last_match(2).to_i
    dice = Regexp.last_match(3).to_i
    incr = Regexp.last_match(4).to_i
    count = 1 if count.zero?
    hash = if mod.present?
             hash_with_mod(mod, count, dice)
           else
             hash_without_mod(count, dice)
           end

    hash[:incr] = incr
    hash[:result] = hash[:result] + incr
    hash
  end

  def dice_by_template(key, dices)
    hash = dices.find { |item| item['key'] == key } || { 'dice' => key }
    hash['dice']
  end

  def roll(count, dice)
    result = []
    count.times { result << rand(1..dice) }
    result.compact
  end

  def hash_with_mod(mod, count, dice)
    result = []
    dice_key = "d#{dice}"
    hash = { mod: mod, dice: { dice_key => [] } }
    count.times do
      value = rand(1..dice)
      result << value
      hash[:dice][dice_key] << value
    end

    hash[:result] = mod == 'h' ? result.max : result.min
    hash
  end

  def hash_without_mod(count, dice)
    result = []
    dice_key = "d#{dice}"
    hash = { dice: { dice_key => [] } }
    count.times do
      value = rand(1..dice)
      result << value
      hash[:dice][dice_key] << value
    end

    hash[:result] = result.sum
    hash
  end
end
