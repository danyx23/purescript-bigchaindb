module BigChainDB where

import Control.Monad.Eff (kind Effect, Eff)
import Data.Newtype

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

foreign import data BIGCHAINDB :: Effect

foreign import bigChainDBDriver :: BigChainDBDriver

foreign import makeEd25519Keypair :: forall eff.
                                     BigChainDBDriver
                                  -> Eff (bigchain :: BIGCHAINDB | eff) Ed25519Keypair
