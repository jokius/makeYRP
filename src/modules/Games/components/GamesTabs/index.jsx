import React from 'react'
import PropTypes from 'prop-types'
import { inject, observer } from 'mobx-react'
import { withRouter } from 'react-router-dom'

import { withStyles } from '@material-ui/core/styles'
import styles from './styles'

import Paper from '@material-ui/core/Paper'
import Tabs from '@material-ui/core/Tabs'
import Tab from '@material-ui/core/Tab'
import { Loading } from '../../../Loading'
import { GameTab } from '../GameTab'

@withStyles(styles)
@withRouter
@inject('games')
@observer
export class GamesTab extends React.Component {
  static propTypes = {
    games: PropTypes.object.isRequired,
    classes: PropTypes.object.isRequired,
  }

  constructor(props, context) {
    super(props, context)
    this.state = {
      value: 0,
    }
  }

  componentDidMount() {
    const { games } = this.props
    games.loadGames()
  }

  handleChange = (event, newValue) => {
    this.setState(oldState => ({ ...oldState, value: newValue }));
  }

  render() {
    const { games, classes } = this.props
    if (games.state === 'new' || games.state === 'pending') {
      return <Loading />
    }

    const { value } = this.state

    return (
      <Paper className={classes.root}>
        <Tabs
          value={value}
          onChange={this.handleChange}
          indicatorColor="primary"
          textColor="primary"
          centered
        >
          <Tab label="Текущие игры" />
          <Tab label="Завершенные игры" />
        </Tabs>

        <GameTab index={0} list={games.open} value={value} />
        <GameTab index={1} list={games.close} value={value} />
      </Paper>
    )
  }
}
