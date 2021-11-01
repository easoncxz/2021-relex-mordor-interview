{-# LANGUAGE OverloadedStrings #-}

module HttpEntities
  ( CounterResponse(..)
  ) where

import qualified Data.Aeson as A

data CounterResponse =
  CounterResponse Int

instance A.ToJSON CounterResponse where
  toJSON (CounterResponse count) = A.object ["value" A..= count]
