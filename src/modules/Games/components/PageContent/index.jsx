import React from 'react'
import { observer } from 'mobx-react'
import PropTypes from 'prop-types'
import Map from '../Map'

@observer
export default class PageContent extends React.Component {
  static propTypes = {
    page: PropTypes.object.isRequired,
  }

  render() {
    const { page } = this.props
    if (page.type === 'map') return <Map page={page} />

    return null
  }
}
