import { isEmpty } from 'lodash'
import ErrorModel from '../../mobx/models/ErrorModel'

const handling = (self, error) => {
  if (!isEmpty(error.err)) {
    switch (error.err.status) {
      case 401:
        self.state = 'pending'
        return
      case 400:
        self.errors = error.res.body.map(item => new ErrorModel({ message: item }))
        self.state = 'error'
        return
      default:
        self.errors = [new ErrorModel({ message: 'Look in the browser console' })]
        self.state = 'error'
        return
    }
  }

  self.errors = [new ErrorModel({ message: error.toString() })]
  console.log('eroor', error) // eslint-disable-line no-console
  self.state = 'error'
}

export {
  handling,
}
