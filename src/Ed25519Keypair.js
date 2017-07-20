// module BigChainDB
exports.bigChainDBDriver = require('bigchaindb-driver');

exports.makeEd25519Keypair = function makeEd25519Keypair(driver) {
  return function() {
    return new driver.Ed25519Keypair();
  }
}

// TODO; give bigchaindb as first argument to all functions

exports.makeOutputImpl = function makeOutput(driver, condition, amount) {
  return function() {
    return driver.Transaction.makeOutput(condition, amount);
  }
}

exports.makeEd25519ConditionImpl = function makeEd25519Condition(driver, publicKey) {
  return driver.Transaction.makeEd25519Condition(publicKey);
}

exports.makeCreateTransactionImpl = function makeCreateTransaction(driver, asset, metadata, outputs) {
  return driver.Transaction.makeCreateTransaction(asset, metadata, outputs);
}

exports.signTransactionImpl = function signTransaction(driver, transaction, privateKey) {
  return driver.Transaction.signTransaction(transaction, privateKey);
}

exports.postTransactionImpl = function postTransaction(connection) {
  return function(signedTransaction) {
    return function() {
      return connection.postTransaction(signedTransaction);
    }
  }
}

exports.createConnectionImpl = function createConnection(driver, bigChainUrl) {
    return function() {
      return new driver.Connection(bigChainUrl);
    }
}
