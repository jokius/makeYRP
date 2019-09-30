import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { observer } from 'mobx-react'

import FormControlLabel from '@material-ui/core/FormControlLabel'
import Checkbox from '@material-ui/core/Checkbox'

@observer
export class CheckboxField extends Component {
  static propTypes = {
    field: PropTypes.object.isRequired,
    label: PropTypes.string,
    type: PropTypes.string,
  }

  static defaultProps = {
    label: null,
    type: 'text',
  }

  render() {
    const { label, field, ...props } = this.props

    return (
      <FormControlLabel
        {...field.bind()}
        checked={field.value}
        control={<Checkbox color="primary" />}
        label={label || field.label}
        labelPlacement="start"
        {...props}
      />
    )
  }
}
