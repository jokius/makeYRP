import React from 'react'
import PropTypes from 'prop-types'
import { inject, observer } from 'mobx-react'

import { withStyles } from '@material-ui/core/styles'
import styles from './styles'

import Paper from '@material-ui/core/Paper'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import DialogTitle from '@material-ui/core/DialogTitle'
import Typography from '@material-ui/core/Typography'
import IconButton from '@material-ui/core/IconButton'
import CloseIcon from '@material-ui/icons/Close'

@withStyles(styles)
@inject('openModals')
@observer
export default class DraggableDialog extends React.Component {
  static propTypes = {
    classes: PropTypes.object.isRequired,
    open: PropTypes.bool.isRequired,
    title: PropTypes.string.isRequired,
    children: PropTypes.node.isRequired,
    onClose: PropTypes.func.isRequired,
    openModals: PropTypes.array.isRequired,
    actions: PropTypes.node,
  }

  static defaultProps = {
    actions: null,
  }

  render() {
    const { classes, open, title, children, actions, onClose, openModals } = this.props
    if (!open) return null
    const Draggable = require('react-draggable')

    return (
      <Draggable cancel={'[class*="MuiDialogContent-root"]'}>
        <Paper className={classes.root} style={{ zIndex: 2000 + openModals.length }}>
          <DialogTitle style={{ cursor: 'move' }}>
            <Typography>{title}</Typography>
            <IconButton className={classes.closeButton} onClick={onClose}>
              <CloseIcon />
            </IconButton>
          </DialogTitle>
          <DialogContent dividers>
            {children}
          </DialogContent>
          <DialogActions>
            {actions}
          </DialogActions>
        </Paper>
      </Draggable>
    )
  }
}
