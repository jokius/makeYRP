import React from 'react'
import { inject, observer } from 'mobx-react'
import PropTypes from 'prop-types'

import { withStyles } from '@material-ui/core'
import styles from './styles'

import BottomNavigationAction from '@material-ui/core/BottomNavigationAction'
import PersonIcon from '@material-ui/icons/Person'
import BuildIcon from '@material-ui/icons/Build'
import PublicIcon from '@material-ui/icons/Public'

@withStyles(styles)
@inject('game', 'leftMenus')
@observer
export default class ActionButtons extends React.Component {
  static propTypes = {
    classes: PropTypes.object.isRequired,
    game: PropTypes.object.isRequired,
    leftMenus: PropTypes.array.isRequired,
  }

  constructor(props, context) {
    super(props, context)
    const { leftMenus } = this.props
    leftMenus.push({ label: 'Персонажи', icon: (<PersonIcon />), type: 'characters' })
    leftMenus.push({ label: 'Карты', icon: (<PublicIcon />), type: 'maps' })
    leftMenus.push({ label: 'Настройки страници', icon: (<BuildIcon />), type: 'pageConfig' })
  }

  onChange = (index) => {
    const { game } = this.props
    game.setCurrentMenu(game.currentMenu === index ? -1 : index)
  }

  render() {
    const { classes, game, leftMenus } = this.props

    return (
      <div className={classes.root}>
        {leftMenus.map((item, index) => (
          <BottomNavigationAction
            key={index}
            className={game.currentMenu === index ? classes.selectMenu : null}
            showLabel
            label={item.label}
            icon={item.icon || null}
            onClick={() => this.onChange(index)}
          />
        ))}
      </div>
    )
  }
}
