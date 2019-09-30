const path = require('path')
const merge = require('webpack-merge')
const common = require('./common.config')
const { ReactLoadablePlugin } = require('react-loadable/webpack')

module.exports = merge(common, {
  context: path.resolve(`${__dirname}/../../src/client`),
  entry: {
    bundle: [
      './index.jsx',
    ],
  },
  output: {
    path: path.resolve(`${__dirname}/../../dist`),
    filename: '[name].js',
    chunkFilename: '[name].js',
    publicPath: '/',
  },
  plugins: [
    new ReactLoadablePlugin({
      filename: './dist/react-loadable.json',
    }),
  ],
})
