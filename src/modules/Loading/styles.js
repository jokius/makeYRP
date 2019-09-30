const baseCircle = (theme) => ({
  border: '3px solid transparent',
  borderTopColor: theme.palette.primary.main,
  borderRightColor: theme.palette.primary.main,
  borderRadius: '50%',
  position: 'absolute',
  top: '50%',
  left: '50%',
  animationName: '$spin',
})

const styles = (theme) => ({
  loader: {
    top: '50%',
  },

  outer: {
    ...baseCircle(theme),
    width: '3.5em',
    height: '3.5em',
    marginLeft: '-1.75em',
    marginTop: '-1.75em',
    animation: 'spin 2s linear infinite',
  },

  middle: {
    ...baseCircle(theme),
    width: '2.1em',
    height: '2.1em',
    marginLeft: '-1.05em',
    marginTop: '-1.05em',
    animation: 'spin 1.75s linear reverse infinite',
  },

  inner: {
    ...baseCircle(theme),
    width: '0.8em',
    height: '0.8em',
    marginLeft: '-0.4em',
    marginTop: '-0.4em',
    animation: 'spin 1.5s linear infinite',
  },

  '@keyframes spin': {
    to: {
      transform: 'rotate(360deg)',
    },
  },
})

export default styles
