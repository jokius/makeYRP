export const  d6roll = (times = 1) => {
  let result = 0;
  for (let i = 1; i <= times; i++) {
    let rand = 0.5 + Math.random() * 6;
    result += Math.round(rand);
  }
  return result;
}
