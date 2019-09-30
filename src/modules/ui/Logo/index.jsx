import React from 'react'
import PropTypes from 'prop-types'

import { withStyles } from '@material-ui/core/styles'

import Grid from '@material-ui/core/Grid'
import styles from './styles'

const Logo = ({ classes }) => (
  <Grid container justify="center" alignItems="center">
    <img src="/public/img/logo.png" alt="" className={classes.logoBody} />
  </Grid>
)

Logo.propTypes = {
  classes: PropTypes.object.isRequired,
}


export default withStyles(styles)(Logo)
