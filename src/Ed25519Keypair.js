// module BigChainDB
exports.bigChainDBDriver = require('bigchaindb-driver');

exports.makeEd25519Keypair = function makeEd25519Keypair(driver) {
  return function() {
    return new driver.Ed25519Keypair();
  }
}

// TODO; give bigchaindb as first argument to all functions

exports.makeOutput = function makeOutput(driver) {
  return function(condition) {
    return function(amount) {
      return function() {
        return driver.Transaction.makeOutput(condition, amount);
      }
    }
  }
}

exports.makeEd25519Condition = function makeEd25519Condition(driver) {
  return function(publicKey) {
    return driver.Transaction.makeEd25519Condition(publicKey);
  }
}

exports.makeCreateTransaction = function makeCreateTransaction(driver) {
  return function(asset) {
    return function(metadata) {
      return function(outputs) {
        return driver.Transaction.makeCreateTransaction(asset, metadata, outputs);
      }
    }
  }
}

exports.signTransaction = function signTransaction(driver) {
  return function(transaction) {
    return function(privateKey) {
      return driver.Transaction.signTransaction(transaction, privateKey);
    }
  }
}

exports.postTransaction = function postTransaction(connection) {
  return function(signedTransaction) {
    return function() {
      return connection.postTransaction(signedTransaction);
    }
  }
}

exports.createConnection = function createConnection(driver) {
  return function(bigChainUrl) {
    return function() {
      return new driver.Connection(bigChainUrl);
    }
  }
}
