import React from 'react'
import { inject, observer } from 'mobx-react'
import PropTypes from 'prop-types'

import DraggableDialog from '../../../ui/DraggableDialog'
import Button from '@material-ui/core/Button'
import { replace } from 'lodash'
import MobxReactForm from 'mobx-react-form'
import { InputField } from '../../../ui/fields/InputField'

@inject('game', 'formId')
@observer
export default class PageModal extends React.Component {
  static propTypes = {
    game: PropTypes.object.isRequired,
    onClose: PropTypes.func.isRequired,
    formId: PropTypes.string.isRequired,
  }

  constructor(props, context) {
    super(props, context)
    const { game, onClose, formId } = this.props

    const hooks = {
      onSuccess(form) {
        game.addPage(form.values())
          .then(() => onClose())
      },
    }

    const uniqueId = field =>
      [replace(field.path, new RegExp('\\.', 'g'), '-'), '--'].join('') + formId

    this.form = new MobxReactForm(game.pageFields, {
      plugins: game.plugins,
      hooks,
      options: { uniqueId },
    })
  }

  render() {
    const { onClose } = this.props
    const name = this.form.$('name')

    return (
      <form onSubmit={this.form.onSubmit}>
        <DraggableDialog
          onClose={onClose}
          open
          title="Новая страница"
          actions={(
            <>
              <Button onClick={onClose} color="primary">
                Отмена
              </Button>
              <Button onClick={() => this.form.submit(this.form)} color="primary">
                Создать
              </Button>
            </>
          )}
        >
          <InputField
            required
            fullWidth
            field={name}
            helperText={name.errors()}
            error={Boolean(name.errors())}
          />
        </DraggableDialog>
      </form>
    )
  }
}
