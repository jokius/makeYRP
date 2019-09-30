import { createMuiTheme } from '@material-ui/core/styles'

const theme = {
  dark: createMuiTheme({
    palette: {
      type: 'dark',
    },
  }),
  light: createMuiTheme({
    palette: {
      type: 'light',
    },
  }),
}

export default theme
