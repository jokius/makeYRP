import { observable } from 'mobx'

export default class ErrorModel {
  @observable message = ''


  constructor(params) {
    const {
      message = '',
    } = params
    this.message = message
  }
}
