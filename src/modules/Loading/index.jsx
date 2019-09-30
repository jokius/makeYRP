import React from 'react'
import { observer } from 'mobx-react'
import PropTypes from 'prop-types'

import { withStyles } from '@material-ui/core/styles'
import styles from './styles'

@withStyles(styles)
@observer
export class Loading extends React.Component {
  static propTypes = {
    classes: PropTypes.object.isRequired,
  }

  render() {
    const { classes } = this.props

    return (
      <div className={classes.loader}>
        <div className={classes.outer} />
        <div className={classes.middle} />
        <div className={classes.inner} />
      </div>
    )
  }
}
