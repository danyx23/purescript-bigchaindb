// module BigChainDB
exports.bigChainDBDriver = require('bigchaindb-driver');

exports.makeEd25519Keypair = function makeEd25519Keypair(driver) {
  return function() {
    return new driver.Ed25519Keypair();
  }
}
