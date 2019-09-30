import palette from '../../../../shared/helpers/palette'

const margin = {
  margin: 5,
}

const styles = () => ({
  root: {
    color: palette.black,
  },

  dropZone: {
    height: 200,
    background: palette.gray52,
    borderWidth: 2,
    borderRadius: 2,
    borderColor: palette.white,
    borderStyle: 'dashed',
    color: palette.white,
    transition: 'border .24s ease-in-out',
    ...margin,
    position: 'relative',
    '&:hover': {
      background: palette.purple51,
    },
  },

  loadIcon: {
    position: 'absolute',
    top: '50%',
    left: '50%',
    marginRight: '-50%',
    transform: 'translate(-50%, -50%)',
    width: 100,
    height: 100,
  },

  colorBox: {
    width: 40,
    height: 40,
    cursor: 'pointer',
  },

  gridItem: {
    ...margin,
  },
})

export default styles
