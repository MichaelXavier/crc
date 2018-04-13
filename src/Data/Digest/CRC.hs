{-# LANGUAGE TypeFamilyDependencies #-}
module Data.Digest.CRC
    ( CRC(..)
    , digest
    ) where


-------------------------------------------------------------------------------
import           Data.ByteString     as BS
import           Data.Vector.Unboxed as V
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------



class CRC a where
  type CRCWord a = r | r -> a
  initCRC :: a
  crcWord :: a -> CRCWord a
  updateDigest :: a -> ByteString -> a
  crcTable :: V.Vector (CRCWord a)


digest :: CRC a => ByteString -> a
digest = updateDigest initCRC
