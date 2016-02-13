{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
module Main
    ( main
    ) where


-------------------------------------------------------------------------------
import           Criterion
import           Criterion.Main
import           Data.ByteString   (ByteString)
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
  ]


-------------------------------------------------------------------------------
digestBenchmarks :: Benchmark
digestBenchmarks = bgroup "digest"
  [ bench "CRC8" (digestBench (Proxy :: Proxy CRC8) )
  , bench "CRC16" (digestBench (Proxy :: Proxy CRC16))
  , bench "CRC32" (digestBench (Proxy :: Proxy CRC32))
  , bench "CRC64" (digestBench (Proxy :: Proxy CRC64))
  ]


-------------------------------------------------------------------------------
example :: ByteString
example = "1234567890"


-------------------------------------------------------------------------------
digestBench :: forall a. (CRC a) => Proxy a -> Benchmarkable
digestBench _ = whnf (digest :: ByteString -> a) example
