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
import { SelectField } from '../../../ui/fields/SelectField'
import MenuItem from '@material-ui/core/MenuItem'
import { Loading } from '../../../Loading'

@withStyles(styles)
@withRouter
@inject('game', 'systems', 'formId')
@observer
export class NewGameForm extends React.Component {
  static propTypes = {
    game: PropTypes.object.isRequired,
    systems: PropTypes.object.isRequired,
    formId: PropTypes.string.isRequired,
    classes: PropTypes.object.isRequired,
    history: PropTypes.object.isRequired,
  }

  constructor(props, context) {
    super(props, context)
    const { game, history, formId } = this.props
    game.setNew()

    const hooks = {
      onSuccess(form) {
        game.create(form.values())
          .then(() => {
            if (game.state === 'error') {
              return
            }

            history.push(links.dynamic(links.base.game, { id: game._id }))
          })
      },
    }

    const uniqueId = field =>
      [replace(field.path, new RegExp('\\.', 'g'), '-'), '--'].join('') + formId

    this.form = new MobxReactForm(game.createFields, {
      hooks,
      plugins: game.plugins,
      options: { uniqueId },
    })
  }

  componentDidMount() {
    const { systems } = this.props
    systems.loadSystems()
  }

  onChange = field => (e) => {
    e.preventDefault()
    field.onChange(e)
    this.form.$('system')
      .invalidate(null)
  }

  render() {
    const { systems, classes } = this.props
    if (systems.state === 'new' || systems.state === 'pending') {
      return <Loading />
    }

    const name = this.form.$('name')
    const system = this.form.$('system')
    return (
      <form onSubmit={this.form.onSubmit} className={classes.form}>
        <Typography component="h1" variant="h5" className={classNames(classes.title, classes.centerCol)}>
          Создание игры
        </Typography>
        <InputField
          className={classes.centerCol}
          variant="outlined"
          required
          fullWidth
          field={name}
          helperText={name.errors()}
          error={Boolean(name.errors())}
        />
        <SelectField
          className={classes.centerCol}
          variant="outlined"
          required
          fullWidth
          field={system}
          helperText={system.errors() || 'Система'}
          error={Boolean(system.errors())}
          onChange={this.onChange}
        >
          <MenuItem value="" disabled />
          {systems.list.map(item => <MenuItem key={item._id} value={item._id}>{item.name}</MenuItem>)}
        </SelectField>
        <Button
          type="submit"
          fullWidth
          variant="contained"
          color="primary"
          className={classNames(classes.submit, classes.centerCol)}
        >
          Создать игру
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
