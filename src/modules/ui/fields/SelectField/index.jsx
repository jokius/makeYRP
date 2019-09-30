import React, { Component } from 'react'
import { observer } from 'mobx-react'
import PropTypes from 'prop-types'
import FormControl from '@material-ui/core/FormControl'
import FormHelperText from '@material-ui/core/FormHelperText'
import Select from '@material-ui/core/Select'

@observer
export class SelectField extends Component {
  static propTypes = {
    field: PropTypes.object.isRequired,
    children: PropTypes.node.isRequired,
    onChange: PropTypes.func,
    helperText: PropTypes.string,
    error: PropTypes.bool,
    displayEmpty: PropTypes.bool,
    disabled: PropTypes.bool,
    multiple: PropTypes.bool,
    className: PropTypes.string,
    fullWidth: PropTypes.bool,
  }

  static defaultProps = {
    displayEmpty: false,
    helperText: '',
    error: false,
    disabled: false,
    multiple: false,
    onChange: null,
    className: '',
    fullWidth: false,
  }

  onChange = field => (e) => {
    e.preventDefault()
    field.onChange(e)
  }

  render() {
    const {
      children,
      onChange,
      error,
      displayEmpty,
      disabled,
      multiple,
      helperText,
      field,
      className,
      fullWidth,
      ...props
    } = this.props

    return (
      <FormControl className={className} fullWidth={fullWidth}>
        <Select
          multiple={multiple}
          disabled={disabled}
          displayEmpty={displayEmpty}
          error={error}
          {...field.bind({ onChange: onChange ? onChange(field) : this.onChange(field) })}
          {...props}
        >
          {children}
        </Select>
        <FormHelperText>{helperText}</FormHelperText>
      </FormControl>
    )
  }
}
