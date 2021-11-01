{-# LANGUAGE NamedFieldPuns #-}

module CounterStorage
  ( Counter -- opaque; no constructors should be exported
  , newCounter
  , peek
  , increment
  , reset
  ) where

import qualified Control.Concurrent.STM as STM

newtype Counter =
  Counter
    { tvar :: STM.TVar Int
    }

newCounter :: IO Counter
newCounter = do
  var <- STM.atomically $ STM.newTVar 0
  return (Counter var)

-- | Get current count
peek :: Counter -> IO Int
peek Counter {tvar} = STM.atomically (STM.readTVar tvar)

-- | Increment and return new count
increment :: Counter -> IO Int
increment Counter {tvar} =
  STM.atomically $ do
    STM.modifyTVar tvar (+ 1)
    STM.readTVar tvar

-- | Reset count and return zero
reset :: Counter -> IO Int
reset Counter {tvar} =
  STM.atomically $ do
    STM.writeTVar tvar 0
    return 0
