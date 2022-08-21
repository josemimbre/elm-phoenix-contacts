const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const CssMinimizerPlugin = require("css-minimizer-webpack-plugin");
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (env, options) => ({
  optimization: {
    minimizer: [
      new TerserPlugin({ cache: true, parallel: true, sourceMap: false }),
      new CssMinimizerPlugin({})
    ]
  },
  entry: {
      './js/app.js': ['./js/app.js'].concat(glob.sync('./vendor/**/*.js'))
  },
  output: {
    filename: 'app.js',
    path: path.resolve(__dirname, '../priv/static/js')
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader']
      },
      {
        test: /\.elm$/,
        exclude: ["/elm-stuff/", "/node_modules"],
        use: {
          loader: 'elm-webpack-loader',
          options: {
            debug: true,
            cwd: path.resolve(__dirname, "elm")
          }
        },
      },
      {
        test: /\.styl$/,
        use: [
          {
            loader: 'style-loader',
          },
          {
            loader: 'css-loader',
          },
          {
            loader: 'stylus-loader',
            options: {
              stylusOptions: {
                use: ["nib"],
              }
            },
          },
        ],
      }
    ]
  },
  plugins: [
    //new MiniCssExtractPlugin({ filename: '../css/app.css' }),
    new CopyWebpackPlugin({
      patterns: [
        { from: 'static/', to: '../' }
      ],
    }),
    new MiniCssExtractPlugin()
  ]
});
