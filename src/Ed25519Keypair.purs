module BigChainDB where

import Data.Newtype (class Newtype)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Eff (kind Effect, Eff)
import Control.Promise 


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

foreign import makeEd25519Condition :: BigChainDBDriver
                                    -> PublicKey
                                    -> Condition


foreign import makeOutput :: forall eff.
                                 BigChainDBDriver
                              -> Condition
                              -> Amount
                              -> Eff (exception :: EXCEPTION | eff) Output

foreign import makeCreateTransaction :: forall asset metadata.
                                     BigChainDBDriver
                                  -> asset
                                  -> metadata
                                  -> Array Output
                                  -> Transaction

foreign import signTransaction :: BigChainDBDriver
                               -> Transaction
                               -> PrivateKey
                               -> SignedTransaction

foreign import createConnection :: forall eff. BigChainDBDriver
                                            -> BigChainUrl
                                            -> Eff (exception :: EXCEPTION | eff) Connection

-- figure out how to deal with the returned promise in an Aff way
foreign import postTransaction :: forall eff a.
                                  Connection
                               -> SignedTransaction
                               -> Eff (bigchain :: BIGCHAINDB | eff) (Promise a)
