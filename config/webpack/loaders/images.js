module.exports = {
  test: /\.(png|jpe?g|gif)$/,
  resourceQuery: /vuetify-preload/,
  use: [
    'vuetify-loader/progressive-loader',
    {
      loader: 'url-loader',
      options: { limit: 8000 },
    },
  ],
}
