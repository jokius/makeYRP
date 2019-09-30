const styles = (theme) => ({
  form: {
    width: '100%',
    marginTop: theme.spacing(8),
    display: 'grid',
    gridTemplateColumns: 'repeat(3, 1fr)',
    gridGap: theme.spacing(1),
  },

  title: {
    color: 'white',
  },

  centerCol: {
    gridColumn: 2,
  },

  submit: {
    margin: theme.spacing(3, 0, 2),
  },
})

export default styles
