module Main where

import Prelude (Unit, bind, discard, ($))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Exception (EXCEPTION)
import BigChainDB
import Debug.Trace (spy)

main :: forall e. Eff (console :: CONSOLE, bigchain :: BIGCHAINDB, exception :: EXCEPTION | e) Unit
main = do
  log "Hello sailor!"
  let driver = bigChainDBDriver
  key <- makeEd25519Keypair driver
  output <- makeOutput driver (makeEd25519Condition driver key.publicKey) "1"
  let transaction = makeCreateTransaction driver asset metadata [ output ]
  let signedTransaction = spy $ signTransaction driver transaction key.privateKey
  log $ "signedTransaction"
  where
    asset = { test: "Test" }
    metadata = { meta: "META" }
