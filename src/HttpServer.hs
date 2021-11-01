{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module HttpServer
  ( counterApplication
  ) where

import Control.Monad.IO.Class (liftIO)
import Data.Proxy (Proxy(Proxy))
import Network.Wai (Application)
import Servant.API ((:<|>)((:<|>)), (:>), Get, JSON, Post)
import Servant.Server (Server, serve)

import CounterStorage (Counter)
import qualified CounterStorage as Storage
import HttpEntities (CounterResponse(CounterResponse))

-- Apologies, I only have hindent set up, which formats Servant's type like this.
type CounterApi
   = "requests" :> Get '[ JSON] CounterResponse :<|> "requests" :> "reset" :> Post '[ JSON] CounterResponse

counterServer :: Counter -> Server CounterApi
counterServer counter = handleIncrement :<|> handleReset
  where
    handleIncrement = do
      current <- liftIO $ Storage.increment counter
      return (CounterResponse current)
    handleReset = do
      zero <- liftIO $ Storage.reset counter
      return (CounterResponse zero)

counterApplication :: Counter -> Application
counterApplication counter =
  serve (Proxy :: Proxy CounterApi) (counterServer counter)
