import React from 'react'
import { inject, observer } from 'mobx-react'
import PropTypes from 'prop-types'
import classNames from 'classnames'

import { withStyles } from '@material-ui/core'
import styles from './styles'

import ButtonGroup from '@material-ui/core/ButtonGroup'
import Button from '@material-ui/core/Button'
import DeleteIcon from '@material-ui/icons/Delete'

@withStyles(styles)
@inject('game')
@observer
export default class PageTabsList extends React.Component {
  static propTypes = {
    classes: PropTypes.object.isRequired,
    game: PropTypes.object.isRequired,
  }

  changeTab = (index) => this.props.game.setCurrentPage(index)

  removePage = (index) => this.props.game.removePage(index)

  render() {
    const { game, classes } = this.props

    return (
      <div>
        {game.pages.map((page, index) => (
          <ButtonGroup
            key={index}
            className={classNames(classes.buttonGroup,
              game.currentPage === index ? classes.backgroundSelect : classes.backgroundMain)}
          >
            <Button onClick={() => this.changeTab(index)}>
              {page.name}
            </Button>
            <Button onClick={() => this.removePage(index)}>
              <DeleteIcon />
            </Button>
          </ButtonGroup>
        ))}
      </div>
    )
  }
}
