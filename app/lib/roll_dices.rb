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
    result = if mod.present?
               result_by_mod(mod, count, dice)
             else
               roll(count, dice).inject(0) { |sum, value| sum + value }
             end

    { result: result + incr }
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

  def result_by_mod(mod, count, dice)
    result = []
    count.times { result << rand(1..dice) }
    mod == 'h' ? result.max : result.min
  end
end
