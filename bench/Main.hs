{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
module Main
    ( main
    ) where


-------------------------------------------------------------------------------
import           Criterion
import           Criterion.Main
import           Data.ByteString   (ByteString)
import qualified Data.ByteString.Lazy as BL
import           Data.Proxy
-------------------------------------------------------------------------------
import           Data.Digest.CRC
import           Data.Digest.CRC16
import           Data.Digest.CRC32
import           Data.Digest.CRC64
import           Data.Digest.CRC8
-------------------------------------------------------------------------------


main :: IO ()
main = defaultMain
  [ digestBenchmarks
  , digestBenchmarksBig
  ]


-------------------------------------------------------------------------------
digestBenchmarks :: Benchmark
digestBenchmarks = bgroup "digest"
  [ bench "CRC8" (digestBench (Proxy :: Proxy CRC8) example)
  , bench "CRC16" (digestBench (Proxy :: Proxy CRC16) example)
  , bench "CRC32" (digestBench (Proxy :: Proxy CRC32) example)
  , bench "CRC64" (digestBench (Proxy :: Proxy CRC64) example)
  ]

digestBenchmarksBig :: Benchmark
digestBenchmarksBig = bgroup "digest_big"
  [ bench "CRC8" (digestBench (Proxy :: Proxy CRC8) bigExample)
  , bench "CRC16" (digestBench (Proxy :: Proxy CRC16) bigExample)
  , bench "CRC32" (digestBench (Proxy :: Proxy CRC32) bigExample)
  , bench "CRC64" (digestBench (Proxy :: Proxy CRC64) bigExample)
  ]


-------------------------------------------------------------------------------
example :: ByteString
example = "1234567890"

bigExample :: ByteString
bigExample = BL.toStrict (BL.fromChunks (replicate 1000000 example))
-------------------------------------------------------------------------------
digestBench :: forall a. (CRC a) => Proxy a -> ByteString -> Benchmarkable
digestBench _ bs = whnf (digest :: ByteString -> a) bs
