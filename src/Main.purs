module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Exception
import BigChainDB
import Data.Newtype (unwrap)
import Debug.Trace (spy)

main :: forall e. Eff (console :: CONSOLE, bigchain :: BIGCHAINDB, exception :: EXCEPTION | e) Unit
main = do
  log "Hello sailor!"
  key <- makeEd25519Keypair bigChainDBDriver
  output <- makeOutput (makeEd25519Condition key.publicKey) "1"
  let transaction = makeCreateTransaction asset metadata [ output ]
  let signedTransaction = spy $ signTransaction transaction key.privateKey
  log $ "signedTransaction"
  where
    asset = { test: "Test" }
    metadata = { meta: "META" }
