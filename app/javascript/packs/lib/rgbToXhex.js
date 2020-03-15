export const rgbToXhex = ({ r, g, b }) => '0x' + decToHex(r) + decToHex(g) + decToHex(b)

const decToHex = value => {
  let hex = Number(value).toString(16);
  if (hex.length < 2) hex = "0" + hex
  return hex
}
