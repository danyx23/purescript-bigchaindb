// module BigChainDB
exports.bigChainDBDriver = require('bigchaindb-driver');

exports.makeEd25519Keypair = function makeEd25519Keypair(driver) {
  return function() {
    return new driver.Ed25519Keypair();
  }
}

// TODO; give bigchaindb as first argument to all functions

exports.makeOutput = function makeOutput(condition) {
  return function(amount) {
    return function() {
      return BigchainDB.Transaction.makeOutput(condition, amount);
    }
  }
}

exports.makeEd25519Condition = function makeEd25519Condition(publickey) {
  return BigchainDB.Transaction.makeEd25519Condition(publickey);
}

exports.makeCreateTransaction = function makeCreateTransaction(asset) {
  return function(metadata) {
    return function(outputs) {
      return BigchainDB.Transaction.makeCreateTransaction(asset, metadata, outputs);
    }
  }
}

exports.signTransaction = function signTransaction(transaction) {
  return function(privateKey) {
    return BigchainDB.Transaction.signTransaction(privateKey);
  }
}

exports.postTransaction = function postTransaction(connection) {
  return function(signedTransaction) {
    return function() {
      return connection.postTransaction(signedTransaction);
    }
  }
}

exports.createConnection = function createConnection(bigChainUrl) {
  return new BigchainDB.Connection(bigChainUrl);
}
