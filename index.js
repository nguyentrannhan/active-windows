try {
  const activeWindows = require('./build/Release/wm.node');
  module.exports = activeWindows;
} catch (ex) {
  module.exports = {}
}
