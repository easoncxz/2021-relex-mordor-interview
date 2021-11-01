module CounterStorageTests where

import qualified CounterStorage as Storage

import Test.Hspec
import Control.Concurrent.Async (replicateConcurrently_)

counterStorageSpec :: Spec
counterStorageSpec =
  describe "The counter backend in CounterStorage" $ do
    it "instantiates separate counters across different calls to newCounter" $ do
      c1 <- Storage.newCounter
      c2 <- Storage.newCounter
      do zero <- Storage.peek c1
         zero `shouldBe` 0
      do zero <- Storage.peek c2
         zero `shouldBe` 0
      _ <- Storage.increment c1
      v1 <- Storage.peek c1
      v2 <- Storage.peek c2
      v1 `shouldBe` 1
      v2 `shouldBe` 0
    it "is somewhat concurrency-safe, at least from lost-updates" $ do
      counter <- Storage.newCounter
      let times = 80000
      replicateConcurrently_ times (Storage.increment counter)
      v <- Storage.peek counter
      v `shouldBe` times
