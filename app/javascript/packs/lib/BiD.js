export class BiD {
  static randomRole(roles) {
    return roles[Math.floor(Math.random() * roles.length)]
  }

  static get getEmptyCharacterTalent() {
    return {
      name: '',
      enable: false,
      editable: true,
    }
  }

  static get getEmptyCharacterRelation() {
    return {
      name: '',
      respect: 0,
      editable: true,
    }
  }
}
