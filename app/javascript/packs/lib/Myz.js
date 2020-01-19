import { d6roll } from './rollDices'

export class Myz {
  static randomRole(roles) {
    return roles[Math.floor(Math.random() * roles.length)]
  }

  static criticalInjury(criticalInjuries) {
    if (criticalInjuries.length === 0) return

    let result = undefined

    do {
      const key = `${d6roll()}${d6roll()}`
      const injury = criticalInjuries[key]

      if (injury) {
        result = { name: injury.name, effect: injury.effect, penalty: injury.penalty }
        if (injury.timeLimit > 0) {
          if (injury.timeLimit === 0.005) {
            result.timeLimit = `Смерть через ${d6roll()} раундов`
          } else if (injury.timeLimit === 0.05) {
            result.timeLimit = `Смерть через ${d6roll()} минут`
          } else if (injury.timeLimit === 0.5) {
            result.timeLimit = `Смерть через ${d6roll()} часов`
          } else {
            result.timeLimit = `Смерть через ${d6roll(result.timeLimit)} дней`
          }
          result.lethal = true

        } else if (injury.timeLimit === -1) {
          result.lethal = true
          result.timeLimit = ''
        } else {
          result.timeLimit = `Первая помощь не нужна`
          result.lethal = false
        }

        if (injury.healingTime > 0) {
          result.healingTime = `Пройдет через ${d6roll(injury.healingTime)} дней`
        } else if (injury.healingTime === -1) {
          result.healingTime = ''
        } else {
          result.healingTime = 'Проходит через незначительное время'
        }
      }

    } while (!result)

    return result
  }

  static nonTypicalDamage() {
    return {
      name: 'Ситуативный урон',
      effect: 'Персонаж находится без  сознания, пока не  погибнет или не вылечится.',
      lethal: true,
      timeLimit: `Смерть через ${d6roll()} дней`,
      healingTime: `Не проходит само`,
    }
  }

  static addSkill(skill) {
    const { name, state, notes } = skill
    return {
      name,
      state,
      notes,
      current: 0,
      min: 0,
      max: 5,
      removable: true,
    }
  }

  static randomMutation(mutations, currentMutations) {
    let result = undefined
    do {
      const key = `${d6roll()}${d6roll()}`
      const mutation = mutations.find(item => item.key === key)
      const currentMutation = currentMutations
        .find(item => item !== '@random' && item.key === key)

      if (mutation && !currentMutation) result = mutation
    } while (!result)

    return result
  }

  static getMutationByKey(mutations, key) {
    return mutations.find(item => item.key === key)
  }

  static randomMisfire(misfires) {
    return misfires[`${d6roll()}`]
  }

  static randomScrap(scraps) {
    return scraps[`${d6roll()}${d6roll()}${d6roll()}`]
  }
}
