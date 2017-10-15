module Main where

import BigChainDB
import Control.Monad.Aff (Canceler(..), launchAff, attempt, liftEff', runAff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE, errorShow, log)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Promise (toAff)
import Data.Either (Either(..), either)
import Debug.Trace (spy)
import Prelude (Unit, bind, discard, ($), const, pure)

main :: forall e. Eff (console :: CONSOLE, bigchain :: BIGCHAINDB, exception :: EXCEPTION | e) (Canceler (console :: CONSOLE, bigchain :: BIGCHAINDB, exception :: EXCEPTION | e))
main = do
  log "Hello sailor!"
  let driver = bigChainDBDriver
  key <- makeEd25519Keypair driver
  output <- makeOutput driver (makeEd25519Condition driver key.publicKey) "1"
  let transaction = makeCreateTransaction driver asset metadata [ output ]
  let signedTransaction = spy $ signTransaction driver transaction key.privateKey
  log $ "signedTransaction"
  connection <- createConnection driver "http://localhost:9984/api/v1/"
  log "connection created"
  post <- postTransaction connection signedTransaction
  log "connection posted"
  --launchAff $ toAff post
  --log "promise resolved"
  let postResult =  (toAff post)
  --liftEff $ either (const $ log "Oh noes!") (const $ log "Yays!") $ liftEff postResult
  runAff errorShow (\val -> log "Success") postResult

  where
    asset = { test: "Test" }
    metadata = { meta: "META" }
