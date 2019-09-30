import React from 'react'
import { observer } from 'mobx-react'

import { withStyles } from '@material-ui/core/styles'
import styles from './styles'

import Grid from '@material-ui/core/Grid'
import Logo from '../../../ui/Logo'
import { GamesTab } from '../../components/GamesTabs'
import { GamesButtonList } from '../../components/GamesButtonList'

@withStyles(styles)
@observer
export default class GamesListPage extends React.Component {
  render() {
    return (
      <Grid container>
        <Grid container>
          <Logo />
        </Grid>
        <Grid container justify="center" alignItems="center">
          <GamesButtonList />
        </Grid>
        <Grid container justify="center" alignItems="center">
          <GamesTab />
        </Grid>
      </Grid>
    )
  }
}
