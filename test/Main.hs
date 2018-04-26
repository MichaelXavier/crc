{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
module Main
    ( main
    ) where


-------------------------------------------------------------------------------
import           Control.Monad.Trans.Resource
import           Data.ByteString              (ByteString)
import           Data.ByteString.Builder
import           Data.ByteString.Lazy         (toStrict)
import           Data.Conduit
import           Data.Conduit.Binary          as CB
import           Data.Conduit.List            as CL
import           Data.Monoid                  as M
import           Data.Proxy
import           Data.Word
import           Test.Tasty
import           Test.Tasty.Golden
-------------------------------------------------------------------------------
import           Data.Digest.CRC
import           Data.Digest.CRC16
import           Data.Digest.CRC32
import           Data.Digest.CRC64
import           Data.Digest.CRC8
-------------------------------------------------------------------------------



main :: IO ()
main = defaultMain testSuite


-------------------------------------------------------------------------------
testSuite :: TestTree
testSuite = testGroup "crc"
  [ digestGolden "crc-64.golden" (Proxy :: Proxy CRC64)
  , digestGolden "crc-32.golden" (Proxy :: Proxy CRC32)
  , digestGolden "crc-16.golden" (Proxy :: Proxy CRC16)
  , digestGolden "crc-8.golden" (Proxy :: Proxy CRC8)
  ]


-------------------------------------------------------------------------------
digestGolden :: forall a. (CRC a, HexBuilder (CRCWord a)) => FilePath -> Proxy a -> TestTree
digestGolden f _ = goldenVsString f goldenPath mkDigests
  where
    goldenPath = "test/data/" M.<> f
    mkDigests = runResourceT $ runConduit $
      sourceFile "test/data/inputs" .|
        CB.lines .|
        CL.map digest .|
        CL.map (toHex :: a -> ByteString) .|
        CL.map toHexLine .|
        sinkLbs


-------------------------------------------------------------------------------
toHex :: (CRC a, HexBuilder (CRCWord a)) => a -> ByteString
toHex = toStrict . toLazyByteString . buildHex . crcWord


-------------------------------------------------------------------------------
class HexBuilder a where
  buildHex :: a -> Builder


instance HexBuilder Word64 where
  buildHex = word64Hex


instance HexBuilder Word32 where
  buildHex = word32Hex


instance HexBuilder Word16 where
  buildHex = word16Hex


instance HexBuilder Word8 where
  buildHex = word8Hex


-------------------------------------------------------------------------------
toHexLine :: ByteString -> ByteString
toHexLine b = "0x" <> b <> "\n"
