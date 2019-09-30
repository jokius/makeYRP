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
@inject('system', 'formId')
@observer
export class NewSystemForm extends React.Component {
  static propTypes = {
    system: PropTypes.object.isRequired,
    formId: PropTypes.string.isRequired,
    classes: PropTypes.object.isRequired,
    history: PropTypes.object.isRequired,
  }

  constructor(props, context) {
    super(props, context)
    const { system, history, formId } = this.props
    system.setNew()

    const hooks = {
      onSuccess(form) {
        system.create(form.values())
          .then(() => {
            if (system.state === 'error') {
              return
            }

            history.push(links.base.games)
          })
      },
    }

    const uniqueId = field =>
      [replace(field.path, new RegExp('\\.', 'g'), '-'), '--'].join('') + formId

    this.form = new MobxReactForm(system.createFields, {
      hooks,
      options: { uniqueId },
    })
  }

  onChange = field => (e) => {
    const { system } = this.props
    e.preventDefault()
    field.onChange(e)
    try {
      JSON.parse(e.target.value)
      if (system.state === 'error') {
        system.setNew()
      }
      this.form.$('raw')
        .invalidate(null)
    } catch (err) {
      return this.form.$('raw')
        .invalidate(err.message)
    }
  }

  render() {
    const { system, classes } = this.props
    if (system.state === 'error') {
      this.form.$('raw')
        .invalidate(system.errors[0].message)
    }

    const raw = this.form.$('raw')
    return (
      <form onSubmit={this.form.onSubmit} className={classes.form}>
        <Typography component="h1" variant="h5" className={classNames(classes.title, classes.centerCol)}>
          Добавить систему
        </Typography>
        <InputField
          className={classes.centerCol}
          variant="outlined"
          required
          fullWidth
          multiline
          rowsMax="6"
          field={raw}
          onChange={this.onChange}
          helperText={raw.errors()}
          error={Boolean(raw.errors())}
        />
        <Button
          type="submit"
          fullWidth
          variant="contained"
          color="primary"
          disabled={Boolean(raw.errors())}
          className={classNames(classes.submit, classes.centerCol)}
        >
          Добавить
        </Button>
        <div className={classes.centerCol}>
          <Link href={links.base.games} variant="body2">
            К списку игр
          </Link>
        </div>
      </form>
    )
  }
}
