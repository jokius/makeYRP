const path = require('path')
const fs = require('fs')
const merge = require('webpack-merge')
const webpack = require('webpack')
const common = require('./common.config')

const nodeModules = {}
fs.readdirSync('node_modules')
  .filter(x => ['.bin'].indexOf(x) === -1)
  .forEach(mod => nodeModules[mod] = `commonjs ${mod}`)

const plugins = [
  new webpack.optimize.LimitChunkCountPlugin({
    maxChunks: 1,
  }),
]

module.exports = merge(common, {
  context: path.resolve(`${__dirname}/../../src/server`),
  entry: {
    server: './index.js',
  },
  target: 'node',
  output: {
    path: path.resolve(`${__dirname}/../../dist`),
    filename: '[name].js',
    libraryTarget: 'commonjs2',
  },
  externals: nodeModules,
  plugins,
})
