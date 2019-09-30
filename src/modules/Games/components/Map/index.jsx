import React from 'react'
import { observer } from 'mobx-react'
import PropTypes from 'prop-types'

@observer
export default class Map extends React.Component {
  static propTypes = {
    page: PropTypes.object.isRequired,
  }

  setStyle = () => {
    const { page } = this.props
    const style = { backgroundImage: {} }
    if (page.backgroundColor) style.backgroundColor = page.backgroundColor
    if (page.backgroundImage) {
      style.backgroundImage = {
        background: `url(${page.backgroundImage}) no-repeat`,
        backgroundSize: 'cover',
      }
    }

    return style
  }

  render() {
    const { page } = this.props
    const reactPixi = require('@inlet/react-pixi')
    const { Stage } = reactPixi
    const style = this.setStyle()
    return (
      <div style={{ backgroundColor: style.backgroundColor || 'inherit' }}>
        <Stage
          style={{ ...style.backgroundImage }}
          width={parseInt(page.width, 10)}
          height={parseInt(page.height, 10)}
          resolution={window.devicePixelRatio}
          options={{
            antialias: true,
            transparent: true,
          }}
        />
      </div>
    )
  }
}
