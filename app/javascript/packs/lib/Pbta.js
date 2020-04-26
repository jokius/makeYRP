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
    }
  }
}
