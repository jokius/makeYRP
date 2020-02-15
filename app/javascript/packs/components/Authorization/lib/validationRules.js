const requiredField = v => !!v || 'обязательное поле'

const emailRules = [
  requiredField,
  v => /.+@.+\..+/.test(v) || 'E-mail не корректен',
]

const requiredRules =  [
  requiredField,
]

export {
  emailRules,
  requiredRules,
}
