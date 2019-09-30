import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { observer } from 'mobx-react'

import TextField from '@material-ui/core/TextField'

@observer
export class InputField extends Component {
  static propTypes = {
    field: PropTypes.object.isRequired,
    label: PropTypes.string,
    onChange: PropTypes.func,
    type: PropTypes.string,
    helperText: PropTypes.string,
    error: PropTypes.bool,
  }

  static defaultProps = {
    label: null,
    type: 'text',
    helperText: '',
    error: false,
    onChange: null,
  }

  onChange = field => (e) => {
    e.preventDefault()
    field.onChange(e)
  }

  render() {
    const { label, field, type, onChange, error, helperText, ...props } = this.props

    return (
      <TextField
        error={error}
        helperText={helperText}
        {...field.bind({ type, onChange: onChange ? onChange(field) : this.onChange(field) })}
        {...props}
        label={label || field.label}
      />
    )
  }
}
