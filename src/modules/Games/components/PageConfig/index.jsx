import React from 'react'
import PropTypes from 'prop-types'
import { inject, observer } from 'mobx-react'

import { withStyles } from '@material-ui/core/styles'
import styles from './styles'

import Dropzone from 'react-dropzone'
import Grid from '@material-ui/core/Grid'
import GetAppIcon from '@material-ui/icons/GetApp'
import palette from '../../../../shared/helpers/palette'
import ColorPickerModal from '../ColorPickerModal'
import { replace } from 'lodash'
import MobxReactForm from 'mobx-react-form'
import { InputField } from '../../../ui/fields/InputField'
import Button from '@material-ui/core/Button'
import ThemeProvider from '@material-ui/styles/ThemeProvider'
import theme from '../../../../theme'
import { SelectField } from '../../../ui/fields/SelectField'
import MenuItem from '@material-ui/core/MenuItem'

@withStyles(styles)
@inject('game', 'openModals', 'formId')
@observer
export class PageConfig extends React.Component {
  static propTypes = {
    classes: PropTypes.object.isRequired,
    game: PropTypes.object.isRequired,
    openModals: PropTypes.array.isRequired,
    formId: PropTypes.string.isRequired,
  }

  constructor(props, context) {
    super(props, context)
    const { game, formId } = this.props
    const self = this

    const hooks = {
      onSuccess(form) {
        self.setState(prevState => ({
          ...prevState,
          submitDisable: true,
        }))
        game.changePage(form.values())
          .then(() => self.setState(prevState => ({
            ...prevState,
            submitDisable: false,
          })))
      },
    }

    const uniqueId = field =>
      [replace(field.path, new RegExp('\\.', 'g'), '-'), '--'].join('') + formId

    this.form = new MobxReactForm(game.pageFields, {
      plugins: game.plugins,
      hooks,
      options: { uniqueId },
    })

    this.state = {
      submitDisable: false,
    }
  }

  onDrop = (files) => {
    const { game } = this.props
    game.changeBackgroundImage(files[0])
  }

  openPicker = () => {
    const key = Date.now()
    this.props.openModals.push(<ColorPickerModal key={key} name="Цвет фона" onClose={() => this.closePicker(key)} />)
  }

  closePicker = (key) => {
    const { openModals } = this.props
    openModals.remove(openModals.find(item => item.key === key.toString()))
    this.props.game.changeBackgroundColor()
  }

  render() {
    const { classes, game } = this.props
    const page = game.pages[game.currentPage]
    let style = {}
    if (page.backgroundImage) {
      style = {
        background: `url(${page.backgroundImage}) no-repeat`,
        backgroundSize: 'cover',
      }
    }

    const name = this.form.$('name')
    const width = this.form.$('width')
    const height = this.form.$('height')
    const grid = this.form.$('grid')
    const gridWidth = this.form.$('gridWidth')
    const gridHeight = this.form.$('gridHeight')

    return (
      <form onSubmit={this.form.onSubmit}>
        <ThemeProvider theme={theme.light}>
          <Grid container justify="center" alignItems="flex-start" className={classes.root}>
            <Dropzone onDrop={this.onDrop} accept="image/jpeg, image/png">
              {({ getRootProps, getInputProps }) => (
                <Grid item xs={12} style={style} className={classes.dropZone} {...getRootProps()}>
                  <input {...getInputProps()} />
                  <GetAppIcon className={classes.loadIcon} />
                </Grid>
              )}
            </Dropzone>
            <Grid container onClick={this.openPicker} className={classes.gridItem}>
              <Grid item xs={9}>
                <p>Цвет фона</p>
              </Grid>
              <Grid item xs={3}>
                <div
                  className={classes.colorBox}
                  style={{ backgroundColor: page.backgroundColor || palette.defaultBg }}
                />
              </Grid>
            </Grid>
            <Grid container className={classes.gridItem}>
              <InputField
                required
                fullWidth
                field={name}
                helperText={name.errors()}
                error={Boolean(name.errors())}
              />
            </Grid>
            <Grid container className={classes.gridItem}>
              <Grid item xs={6}>
                <InputField
                  required
                  fullWidth
                  type="number"
                  field={width}
                  helperText={width.errors()}
                  error={Boolean(width.errors())}
                />
              </Grid>
              <Grid item xs={6}>
                <InputField
                  required
                  fullWidth
                  type="number"
                  field={height}
                  helperText={height.errors()}
                  error={Boolean(height.errors())}
                />
              </Grid>
            </Grid>
            <Grid container className={classes.gridItem}>
              <SelectField
                variant="outlined"
                required
                fullWidth
                displayEmpty
                field={grid}
                helperText={grid.errors() || 'Вид сетки'}
                error={Boolean(grid.errors())}
                onChange={this.onChange}
              >
                <MenuItem value="">Нет</MenuItem>
                <MenuItem value="square">Квадрат</MenuItem>
                <MenuItem value="hex">Гекс</MenuItem>
              </SelectField>
            </Grid>
            <Grid container className={classes.gridItem}>
              <Grid item xs={6}>
                <InputField
                  required
                  fullWidth
                  type="number"
                  field={gridWidth}
                  helperText={gridWidth.errors()}
                  error={Boolean(gridWidth.errors())}
                  disabled={grid.values() === ''}
                />
              </Grid>
              <Grid item xs={6}>
                <InputField
                  required
                  fullWidth
                  type="number"
                  field={gridHeight}
                  helperText={gridHeight.errors()}
                  error={Boolean(gridHeight.errors())}
                  disabled={grid.values() === ''}
                />
              </Grid>
            </Grid>
            <Button
              className={classes.gridItem}
              type="submit"
              fullWidth
              variant="contained"
              color="primary"
              disabled={this.state.submitDisable}
            >
              Изменить
            </Button>
          </Grid>
        </ThemeProvider>
      </form>
    )
  }
}
