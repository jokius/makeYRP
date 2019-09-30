import React from 'react'
import { inject, observer } from 'mobx-react'
import PropTypes from 'prop-types'

import { withStyles } from '@material-ui/core'
import styles from './styles'

import Fab from '@material-ui/core/Fab'
import AddIcon from '@material-ui/icons/Add'
import PageTabsList from '../PageTabsList'
import PageModal from '../PageModal'
import ActionButtons from '../ActionButtons'

@withStyles(styles)
@inject('openModals')
@observer
export default class HeadMenu extends React.Component {
  static propTypes = {
    classes: PropTypes.object.isRequired,
    openModals: PropTypes.array.isRequired,
  }

  addPageModal = () => {
    const key = Date.now()
    this.props.openModals.push(<PageModal key={key} onClose={() => this.closePageModal(key)} />)
  }

  closePageModal = (key) => {
    const { openModals } = this.props
    openModals.remove(openModals.find(item => item.key === key.toString()))
  }

  render() {
    const { classes } = this.props

    return (
      <div className={classes.headMenus}>
        <ActionButtons />
        <PageTabsList />
        <Fab color="primary" onClick={this.addPageModal}>
          <AddIcon />
        </Fab>
      </div>
    )
  }
}
