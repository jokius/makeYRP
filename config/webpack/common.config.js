const path = require('path')
const webpack = require('webpack')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const CompressionPlugin = require('compression-webpack-plugin')

const envRaw = require(`../${process.env.APP_ENV || 'development'}.env.json`)

const ENV = {}
Object.keys(envRaw).map(key => ENV[key] = JSON.stringify(envRaw[key]))

let plugins = [
  new webpack.DefinePlugin({
    'process.env': {
      NODE_ENV: JSON.stringify(process.env.NODE_ENV || 'development'),
      ...ENV,
    },
  }),
]

let eslint = {}

if (process.env.NODE_ENV !== 'production') {
  eslint = {
    test: /\.(js|jsx)$/,
    enforce: 'pre',
    exclude: /node_modules/,
    loader: 'eslint-loader',
    options: {
      emitWarning: true,
    },
  }
}

if (process.env.NODE_ENV === 'production') {
  plugins = [
    ...plugins,
    new UglifyJsPlugin({
      parallel: true,
      sourceMap: false,
      extractComments: true,
      uglifyOptions: {
        ecma: 6,
      },
    }),
    new CompressionPlugin(),
    new webpack.SourceMapDevToolPlugin({
      filename: '[file].map',
      test: /\.(js|jsx)($|\?)/i,
      exclude: /vendor\..+\.js/,
    }),
  ]
}

module.exports = {
  devtool: process.env.NODE_ENV === 'production' ? false : 'inline-source-map',
  resolve: {
    extensions: ['.js', '.jsx'],
    modules: [
      path.resolve(`${__dirname}/../../src/shared`),
      path.resolve(`${__dirname}/../../node_modules`),
    ],
  },
  module: {
    rules: [
      eslint,
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: [
          {
            loader: 'babel-loader',
            options: {
              presets: ['@babel/preset-env'],
            },
          },
        ],
      },
      {
        test: /\.(png|woff|woff2|eot|ttf|svg|jpg)$/,
        use: [
          {
            loader: 'url-loader',
            options: {
              limit: 8192,
            },
          },
        ],
      },
      {
        test: /\.css$/i,
        use: ['style-loader', 'css-loader'],
      },
    ],
  },
  optimization: {
    splitChunks: {
      cacheGroups: {
        vendor: {
          chunks: 'all',
          test: /node_modules\/*\/(?!@material-ui)/,
        },
        material_ui: {
          chunks: 'all',
          test: /node_modules\/@material-ui/,
        },
      },
    },
  },
  plugins,
}
