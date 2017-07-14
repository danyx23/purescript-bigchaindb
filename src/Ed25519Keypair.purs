module BigChainDB where

import Data.Newtype
import Data.Maybe
import Control.Monad.Eff.Exception
import Control.Bind ((=<<))
import Control.Monad.Eff (kind Effect, Eff)

foreign import data BigChainDBDriver :: Type

-- foreign import data Ed25519Keypair :: Type

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


foreign import data BIGCHAINDB :: Effect

foreign import bigChainDBDriver :: BigChainDBDriver

foreign import makeEd25519Keypair :: forall eff.
                                     BigChainDBDriver
                                  -> Eff (bigchain :: BIGCHAINDB | eff) Ed25519Keypair

-- Amount is a number represented as a string in bigchaindb - not sure how we want to treat this
type Amount = String

foreign import data Condition = Type

foreign import data Transaction = Type

foreign import data SignedTransaction = Type

type Output =
  { condition :: Condition
  , amount :: Amount
  , public_keys :: Array PublicKey
  }

foreign import makeOutput :: forall eff.
                                    Condition
                                 -> Amount
                                 -> Eff (exception :: EXCEPTION | eff) Output

foreign import makeEd25519Condition :: PublicKey -> Condition


foreign import makeCreateTransaction :: forall eff asset metadata.
                                        asset
                                     -> metadata
                                     -> Array Output
                                     -> Transaction

foreign import signTransaction :: Transaction
                               -> PrivateKey
                               -> SignedTranscation

foreign import data Connection = Type

-- figure out how to deal with the returned promise in an Aff way
foreign import postTransaction :: Connection
                               -> SignedTranscation
                               -> Eff (bigchain :: BIGCHAINDB | eff) ()
