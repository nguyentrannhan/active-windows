
if (process.platform === 'darwin' && process.arch === 'x64') {
  module.exports = {};
} else {
  const activeWindows = require('./build/Release/wm');
  module.exports = activeWindows;
}
