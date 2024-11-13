
if (process.platform === 'darwin') {
  module.exports = {};
} else {
  const activeWindows = require('node-gyp-build')(__dirname)
  module.exports = activeWindows;
}
