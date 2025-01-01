
if (process.platform === 'darwin' && (process.arch === 'x64' || process.arch === 'x32')) {
  module.exports = {};
} else {
  const activeWindows = require('./build/Release/wm.node');
  module.exports = activeWindows;
}
