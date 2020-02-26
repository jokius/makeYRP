export const rgbToXhex = ({ r, g, b }) => {
  let color = '0x'
  color += parseInt(r, 16)
  color += parseInt(g, 16)
  return color + parseInt(b, 16)
}
