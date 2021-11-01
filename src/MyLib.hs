{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module MyLib
  ( defaultMain
  -- Exposed for testing purposes
  , application
  ) where

import Network.Wai (Application)
import Network.Wai.Handler.Warp (run)

import CounterStorage (newCounter)
import HttpServer (counterApplication)

-- TODO: You should implement this function. See the separately provided
-- description on what the application should do.
--
-- Hint, scotty, servant and yesod are libraries that can provide the 'Application'.
application :: IO Application
application = do
  counter <- newCounter
  return (counterApplication counter)

defaultMain :: IO ()
defaultMain = run 8080 =<< application
