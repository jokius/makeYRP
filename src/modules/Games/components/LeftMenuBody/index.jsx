import React from 'react'
import { inject, observer } from 'mobx-react'
import PropTypes from 'prop-types'

import { withStyles } from '@material-ui/core'
import styles from './styles'

import Paper from '@material-ui/core/Paper'
import { PageConfig } from '../PageConfig'

@withStyles(styles)
@inject('game', 'leftMenus')
@observer
export default class LeftMenuBody extends React.Component {
  static propTypes = {
    classes: PropTypes.object.isRequired,
    game: PropTypes.object.isRequired,
    leftMenus: PropTypes.array.isRequired,
  }

  menuBody = () => {
    const { leftMenus, game } = this.props
    switch (leftMenus[game.currentMenu].type) {
      case 'pageConfig':
        return <PageConfig />
      case 'map':
        return ''
      default:
        return ''
    }
  }

  render() {
    const { classes, game } = this.props

    return game.currentMenu >= 0 ? (
      <Paper className={classes.menuBody}>
        {this.menuBody()}
      </Paper>
    ) : null
  }
}
