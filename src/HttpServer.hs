{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}

module HttpServer
  ( counterApplication
  ) where

import Data.Proxy (Proxy(Proxy))
import Data.Text (Text)
import Network.Wai (Application)
import Servant.API
  ( (:<|>)((:<|>))
  , (:>)
  , Get
  , Header
  , Headers
  , JSON
  , Post
  , addHeader
  )
import Servant.Server (Server, serve)

import CounterStorage (Counter)
import qualified CounterStorage as Storage
import HttpEntities (CounterResponse(CounterResponse))

type CacheControlHeader = Header "Cache-Control" Text

-- Apologies, I only have hindent set up, which formats Servant's type like this.
type CounterApi
   = "requests" :> Get '[ JSON] (Headers '[ CacheControlHeader] CounterResponse) :<|> "requests" :> "reset" :> Post '[ JSON] CounterResponse

counterServer :: Counter -> Server CounterApi
counterServer counter = handleIncrement :<|> handleReset
  where
    handleIncrement
      -- | Important: the returned count should not count the request
      -- that is currently being handled! Off-by-one error otherwise.
      -- We should peek, remember the value, and only then increment.
     = do
      current <- Storage.peek counter
      _ <- Storage.increment counter
      return $ addHeader ("no-store" :: Text) (CounterResponse current)
    handleReset = do
      zero <- Storage.reset counter
      return (CounterResponse zero)

counterApplication :: Counter -> Application
counterApplication counter =
  serve (Proxy :: Proxy CounterApi) (counterServer counter)
