import React from 'react'
import { observer } from 'mobx-react'

import { withStyles } from '@material-ui/core/styles'
import styles from './styles'

import Grid from '@material-ui/core/Grid'
import Logo from '../../../ui/Logo'
import { RegistrationForm } from '../../components/RegistrationForm'

@withStyles(styles)
@observer
export default class RegistrationPage extends React.Component {
  render() {
    return (
      <Grid container>
        <Grid container>
          <Logo />
        </Grid>
        <Grid container justify="center" alignItems="center">
          <RegistrationForm />
        </Grid>
      </Grid>
    )
  }
}
