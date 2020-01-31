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

  static get getEmptyTeamRelation() {
    return {
      name: '',
      enable: false,
      editable: true,
    }
  }

  static get getEmptyTeamImprovements() {
    return {
      name: '',
      max: 1,
      current: 0,
    }
  }

  static get getEmptyMinion() {
    return {
      name: '',
      type: 'gang',
      weakened: false,
      ineffective: false,
      useless: false,
      protection: false,
    }
  }
}
