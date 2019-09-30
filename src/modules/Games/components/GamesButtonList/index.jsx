import React from 'react'
import PropTypes from 'prop-types'
import { inject, observer } from 'mobx-react'

import Grid from '@material-ui/core/Grid'
import Button from '@material-ui/core/Button'
import links from '../../../../shared/helpers/links'

@inject('auth')
@observer
export class GamesButtonList extends React.Component {
  static propTypes = {
    auth: PropTypes.object.isRequired,
  }

  list() {
    const { auth } = this.props
    const buttons = [
      <Grid item key={0}>
        <Button
          type="button"
          variant="contained"
          color="primary"
          href={links.base.newGame}
        >
          Создать игру
        </Button>
      </Grid>,
    ]

    if (auth.admin) {
      buttons.push(
        <Grid item key={1}>
          <Button
            type="button"
            variant="contained"
            color="primary"
            href={links.base.newSystem}
          >
            Добавить систему
          </Button>
        </Grid>,
      )
    }

    return buttons
  }

  render() {
    return (
      <>
        {this.list()}
      </>
    )
  }
}
