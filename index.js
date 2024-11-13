
if (process.platform === 'darwin') {
  module.exports = {};
} else {
  const activeWindows = require('./build/Release/wm.node');
  module.exports = activeWindows;
}
