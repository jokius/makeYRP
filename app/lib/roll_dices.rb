# frozen_string_literal: true

class RollDices
  def call(raw_roll, game_id)
    template = Game.find(game_id).system.template['template']

    raw_roll.each_with_object({}) do |(key, value), result|
      dice = dice_by_template(key, template['dices'] || [])
      face = dice.split(/d/)[1].to_i

      result[key] = roll(value, face)
    end
  end

  private

  def dice_by_template(key, dices)
    hash = dices.find { |item| item['key'] == key } || { 'dice' => key }
    hash['dice']
  end

  def roll(value, face)
    result = []
    value.times { result << rand(1..face) }
    result.compact
  end
end
