{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

-- System under test
import MyLib (application)

import CounterStorageTests (counterStorageSpec)

import qualified Hedgehog.Gen as Gen
import qualified Hedgehog.Range as Range
import Test.Hspec
import Test.Hspec.Hedgehog

import Control.Lens ((^?))
import Control.Monad.Trans (liftIO)
import Data.Aeson (Value(Null))
import Data.Aeson.Lens (_Number, key)
import Data.Foldable (for_)
import Network.Wai.Handler.Warp (withApplication)
import Network.Wreq (get, post, responseBody)

main :: IO ()
main =
  hspec $ do
    counterStorageSpec
    officialSpec

officialSpec :: Spec
officialSpec =
  withServer $ describe "Server is alive" $ do
    it "has an endpoint for requests" $ \port -> do
      got <- get ("http://localhost:"<> show port <> "/requests")
      (got ^? responseBody . key "value" . _Number) `shouldBe` Just 0
    it "counts the requests" $ \port -> hedgehog $ do
      -- WARNING: This test has shown to be really slow on some systems,
      -- especially on macs. If you have the chance, try running the tests on a
      -- linux machine instead
      n <- forAll $ Gen.integral (Range.linear 0 100)

      -- Prepare
      _ <- liftIO $ post ("http://localhost:"<> show port <> "/requests/reset") Null
      for_ [0 :: Int .. n-1] $ \_ -> liftIO $ get ("http://localhost:"<> show port <> "/requests")

      -- Execute test
      got <- liftIO $ get ("http://localhost:"<> show port <> "/requests")

      -- Verify results
      (got ^? responseBody . key "value" . _Number) === Just (fromIntegral n)
  where
    withServer = around $ \f ->
      withApplication application $ \port ->
        f port
