export class Pbta {
  static randomRole(roles) {
    return roles[Math.floor(Math.random() * roles.length)]
  }

  static newItem() {
    return {
      name: 'Новый предмет',
      description: '',
      damage: 0,
      protection: 0,
      quantity: 1,
      edit: true,
      tags: [],
    }
  }

  static mapMoves(list, moves) {
    return list.map(item => {
      if (moves.find(move => move.name === item.name)) return
      const value = item
      value.remove = true

      return {
        text: item.name,
        value,
      }
    }).filter(Boolean)
  }
}
