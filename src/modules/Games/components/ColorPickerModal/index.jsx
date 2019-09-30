import React from 'react'
import { inject, observer } from 'mobx-react'
import PropTypes from 'prop-types'

import DraggableDialog from '../../../ui/DraggableDialog'
import { ChromePicker } from 'react-color'
import palette from '../../../../shared/helpers/palette'

@inject('game')
@observer
export default class ColorPickerModal extends React.Component {
  static propTypes = {
    game: PropTypes.object.isRequired,
    onClose: PropTypes.func.isRequired,
    name: PropTypes.string.isRequired,
  }

  render() {
    const { game, name, onClose } = this.props
    const page = game.pages[game.currentPage]

    return (
      <DraggableDialog
        onClose={onClose}
        open
        title={name}
      >
        <div>
          <ChromePicker
            color={page.backgroundColor || palette.defaultBg}
            onChange={(color) => game.setPageBackgroundColor(color)}
            disableAlpha
          />
        </div>
      </DraggableDialog>
    )
  }
}
