{-# LANGUAGE NamedFieldPuns #-}

module CounterStorage
  ( Counter -- opaque; no constructors should be exported
  , newCounter
  , peek
  , increment
  , reset
  ) where

import qualified Control.Concurrent.STM as STM
import Control.Monad.IO.Class (MonadIO, liftIO)

newtype Counter =
  Counter
    { tvar :: STM.TVar Int
    }

newCounter :: IO Counter
newCounter = do
  var <- STM.atomically $ STM.newTVar 0
  return (Counter var)

-- | Get current count
peek :: (MonadIO m) => Counter -> m Int
peek Counter {tvar} = liftIO $ STM.atomically (STM.readTVar tvar)

-- | Increment and return new count
increment :: (MonadIO m) => Counter -> m Int
increment Counter {tvar} =
  liftIO $
  STM.atomically $ do
    STM.modifyTVar tvar (+ 1)
    STM.readTVar tvar

-- | Reset count and return zero
reset :: (MonadIO m) => Counter -> m Int
reset Counter {tvar} =
  liftIO $
  STM.atomically $ do
    STM.writeTVar tvar 0
    return 0
