import React from 'react'
import PropTypes from 'prop-types'
import { inject, observer } from 'mobx-react'

import { withStyles } from '@material-ui/core/styles'
import styles from './styles'

import Typography from '@material-ui/core/Typography'
import Grid from '@material-ui/core/Grid'
import Divider from '@material-ui/core/Divider'
import links from '../../../../shared/helpers/links'
import { withRouter } from 'react-router'

@withStyles(styles)
@withRouter
@inject('game')
@observer
export class GameTab extends React.Component {
  static propTypes = {
    game: PropTypes.object.isRequired,
    list: PropTypes.array.isRequired,
    index: PropTypes.number.isRequired,
    value: PropTypes.number.isRequired,
    classes: PropTypes.object.isRequired,
    history: PropTypes.object.isRequired,
  }

  joinGame(id) {
    const { history, game } = this.props
    game.setId(id)
    history.push(links.dynamic(links.base.game, { id }))
  }

  render() {
    const { list, index, value, classes } = this.props

    return (
      <Typography
        component="div"
        role="tabpanel"
        hidden={value !== index}
        id={`simple-tabpanel-${index}`}
        aria-labelledby={`simple-tab-${index}`}
      >
        {list.map(game => (
          <Grid container key={game._id} onClick={() => this.joinGame(game._id)}>
            <Grid container spacing={4}>
              <Grid item className={classes.name}>
                {game.name}
              </Grid>
              <Grid item className={classes.master}>
                <span>Ведущий: </span>
                {game.master.name}
              </Grid>
            </Grid>
            <Grid container className={classes.users}>
              <Grid item>
                <span>Игроки: </span>
                {game.users.length > 0 ? game.users.map(user => user.name).join(', ') : 'Нет'}
              </Grid>
            </Grid>
            <Divider className="w100" />
          </Grid>
        ))}
      </Typography>
    )
  }
}
