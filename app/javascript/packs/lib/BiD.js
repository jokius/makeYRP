export class BiD {
  static randomRole(roles) {
    return roles[Math.floor(Math.random() * roles.length)]
  }
}
