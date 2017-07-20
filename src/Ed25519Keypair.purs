module BigChainDB
  ( BIGCHAINDB
  , BigChainDBDriver
  , BigChainUrl
  , Condition
  , Transaction
  , SignedTransaction
  , Connection
  , Amount
  , BigChainUrl
  , PublicKey
  , PrivateKey
  , Ed25519Keypair
  , Operation
  , Output
  , bigChainDBDriver
  , makeEd25519Keypair
  , makeEd25519Condition
  , makeCreateTransaction
  , makeOutput
  , signTransaction
  , createConnection
  , postTransaction
  ) where

import Data.Newtype (class Newtype)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Eff (kind Effect, Eff)
import Control.Promise
import Data.Function.Uncurried


-- foreign import data Ed25519Keypair :: Type


foreign import data BigChainDBDriver :: Type

foreign import data Condition :: Type

foreign import data Transaction :: Type

foreign import data SignedTransaction :: Type

foreign import data Connection :: Type

type Amount = String

type BigChainUrl = String

newtype PublicKey = PublicKey String
derive instance newtypePublicKey :: Newtype PublicKey _

newtype PrivateKey = PrivateKey String
derive instance newtypePrivateKey :: Newtype PrivateKey _

type Ed25519Keypair =
  { publicKey :: PublicKey
  , privateKey :: PrivateKey
  }

data Operation
  = Create
  | Transfer


type Output =
  { condition :: Condition
  , amount :: Amount
  , public_keys :: Array PublicKey
  }

foreign import data BIGCHAINDB :: Effect



foreign import bigChainDBDriver :: BigChainDBDriver

foreign import makeEd25519Keypair :: forall eff.
                                     BigChainDBDriver
                                  -> Eff (bigchain :: BIGCHAINDB | eff) Ed25519Keypair

foreign import makeEd25519ConditionImpl :: Fn2 BigChainDBDriver PublicKey Condition

makeEd25519Condition :: BigChainDBDriver
                        -> PublicKey
                        -> Condition
makeEd25519Condition = runFn2 makeEd25519ConditionImpl

foreign import makeOutputImpl :: forall eff. Fn3 BigChainDBDriver Condition Amount (Eff (exception :: EXCEPTION | eff) Output)

makeOutput :: forall eff. BigChainDBDriver
                       -> Condition
                       -> Amount
                       -> Eff (exception :: EXCEPTION | eff) Output
makeOutput = runFn3 makeOutputImpl

foreign import makeCreateTransactionImpl :: forall asset metadata. Fn4 BigChainDBDriver asset metadata (Array Output) Transaction

makeCreateTransaction :: forall asset metadata.
                                     BigChainDBDriver
                                  -> asset
                                  -> metadata
                                  -> Array Output
                                  -> Transaction
makeCreateTransaction = runFn4 makeCreateTransactionImpl

foreign import signTransactionImpl :: Fn3 BigChainDBDriver Transaction PrivateKey SignedTransaction

signTransaction :: BigChainDBDriver
                               -> Transaction
                               -> PrivateKey
                               -> SignedTransaction
signTransaction = runFn3 signTransactionImpl

foreign import createConnectionImpl :: forall eff. Fn2 BigChainDBDriver BigChainUrl (Eff (exception :: EXCEPTION | eff) Connection)

createConnection :: forall eff. BigChainDBDriver
                                            -> BigChainUrl
                                            -> Eff (exception :: EXCEPTION | eff) Connection
createConnection = runFn2 createConnectionImpl

-- figure out how to deal with the returned promise in an Aff way
foreign import postTransactionImpl :: forall eff a. Fn2 Connection SignedTransaction (Eff (bigchain :: BIGCHAINDB | eff) (Promise a))

postTransaction :: forall eff a.
                                  Connection
                               -> SignedTransaction
                               -> Eff (bigchain :: BIGCHAINDB | eff) (Promise a)
postTransaction = runFn2 postTransactionImpl
