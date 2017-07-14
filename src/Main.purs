module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import BigChainDB
import Data.Newtype (unwrap)

main :: forall e. Eff (console :: CONSOLE, bigchain :: BIGCHAINDB | e) Unit
main = do
  log "Hello sailor!"
  key <- makeEd25519Keypair bigChainDBDriver
  log $ unwrap key.publicKey
