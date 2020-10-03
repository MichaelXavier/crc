{-# LANGUAGE CPP                    #-}
#if __GLASGOW_HASKELL__ >= 800
{-# LANGUAGE TypeFamilyDependencies #-}
#else
{-# LANGUAGE TypeFamilies           #-}
#endif
module Data.Digest.CRC
    ( CRC(..)
    , digest
    , digestWithInitial
    ) where


-------------------------------------------------------------------------------
import           Data.ByteString     as BS
import           Data.Vector.Unboxed as V
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------



class CRC a where
#if __GLASGOW_HASKELL__ >= 800
  type CRCWord a = r | r -> a
#else
  type CRCWord a
#endif
  initCRC :: a
  crcWord :: a -> CRCWord a
  updateDigest :: a -> ByteString -> a
  crcTable :: V.Vector (CRCWord a)


digest :: CRC a => ByteString -> a
digest = updateDigest initCRC

digestWithInitial :: CRC a => a -> ByteString -> a
digestWithInitial = updateDigest