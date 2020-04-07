module.exports = {
  test: /\.s[ac]ss$/i,
  use: [
    'vue-style-loader',
    'css-loader',
    {
      loader: 'sass-loader',
      options: {
        implementation: require('dart-sass'),
      },
    },
  ],
}
