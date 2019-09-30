import React from 'react'
import PropTypes from 'prop-types'
import { inject, observer } from 'mobx-react'
import MobxReactForm from 'mobx-react-form'
import { withRouter } from 'react-router-dom'
import classNames from 'classnames'
import { replace } from 'lodash'

import { withStyles } from '@material-ui/core/styles'
import styles from './styles'

import Button from '@material-ui/core/Button'
import { InputField } from '../../../ui/fields/InputField'
import Typography from '@material-ui/core/Typography'
import Link from '@material-ui/core/Link'
import links from '../../../../shared/helpers/links'

@withStyles(styles)
@withRouter
@inject('auth', 'formId')
@observer
export class RegistrationForm extends React.Component {
  static propTypes = {
    auth: PropTypes.object.isRequired,
    formId: PropTypes.string.isRequired,
    classes: PropTypes.object.isRequired,
    history: PropTypes.object.isRequired,
  }

  constructor(props, context) {
    super(props, context)
    const { auth, history, formId } = this.props
    auth.setNew()

    const hooks = {
      onSuccess(form) {
        auth.registration(form.values())
          .then(() => {
            if (auth.state === 'error') {
              return
            }

            history.push(links.base.games)
          })
      },
    }

    const uniqueId = field =>
      [replace(field.path, new RegExp('\\.', 'g'), '-'), '--'].join('') + formId

    this.form = new MobxReactForm(auth.registrationFields, {
      plugins: auth.plugins,
      hooks,
      options: { uniqueId },
    })
  }

  onChange = field => (e) => {
    e.preventDefault()
    field.onChange(e)
    if (this.props.auth.state === 'error') {
      this.props.auth.setNew()
    }
    this.form.$('login')
      .invalidate(null)
  }

  render() {
    const { auth, classes } = this.props
    if (auth.state === 'error') {
      this.form.$('login')
        .invalidate(auth.errors[0].message)
    }

    const login = this.form.$('login')
    const name = this.form.$('name')
    const password = this.form.$('password')
    return (
      <form onSubmit={this.form.onSubmit} className={classes.form}>
        <Typography component="h1" variant="h5" className={classNames(classes.title, classes.centerCol)}>
          Регистрация
        </Typography>
        <InputField
          className={classes.centerCol}
          variant="outlined"
          required
          fullWidth
          field={login}
          helperText={login.errors()}
          error={Boolean(login.errors())}
          onChange={this.onChange}
        />
        <InputField
          className={classes.centerCol}
          variant="outlined"
          required
          fullWidth
          field={name}
          helperText={name.errors()}
          error={Boolean(name.errors())}
        />
        <InputField
          className={classes.centerCol}
          variant="outlined"
          required
          fullWidth
          field={password}
          helperText={password.errors()}
          error={Boolean(password.errors())}
        />
        <Button
          type="submit"
          fullWidth
          variant="contained"
          color="primary"
          className={classNames(classes.submit, classes.centerCol)}
        >
          Зарегестрироватся
        </Button>
        <div className={classes.centerCol}>
          <Link href="/" variant="body2">
            Уже есть аккаунт? Войти
          </Link>
        </div>
      </form>
    )
  }
}
