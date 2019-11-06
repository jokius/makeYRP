import React from 'react'
import PropTypes from 'prop-types'
import { inject, observer } from 'mobx-react'

import { Loading } from '../../../Loading'
import HeadMenu from '../../components/HeadMenu'
import PageContent from '../../components/PageContent'
import LeftMenuBody from '../../components/LeftMenuBody'

@inject('game', 'openModals')
@observer
export default class GamePage extends React.Component {
  static propTypes = {
    game: PropTypes.object.isRequired,
    openModals: PropTypes.array.isRequired,
  }

  componentDidMount() {
    const { game } = this.props
    game.load()
  }

  render() {
    const { game, openModals } = this.props
    if (typeof window === 'undefined' || game.state === 'new' || game.state === 'pending') {
      return <Loading />
    }

    return (
      <div>
        <HeadMenu />
        <LeftMenuBody />
        <PageContent page={game.pageObj} />
        {openModals.length > 0 && openModals.map(item => item)}
      </div>
    )
  }
}
