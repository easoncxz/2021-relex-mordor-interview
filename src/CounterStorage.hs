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

peek :: Counter -> IO Int
peek Counter {tvar} = STM.atomically (STM.readTVar tvar)

-- | Returns new count
increment :: Counter -> IO Int
increment Counter {tvar} =
  STM.atomically $ do
    STM.modifyTVar tvar (+ 1)
    STM.readTVar tvar

reset :: Counter -> IO ()
reset Counter {tvar} = STM.atomically $ STM.writeTVar tvar 0
