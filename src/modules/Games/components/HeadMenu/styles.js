const styles = (theme) => ({
  headMenus: {
    position: 'fixed',
    zIndex: 1000,
    display: 'grid',
    gridTemplateColumns: 'repeat(3, max-content)',
    gridGap: theme.spacing(1),
  },
})

export default styles
