-- 
-- Copyright (c) 2017 Mathieu Kerjouan <contact@steepath.eu>
--
-- Permission to use,  copy, modify, and distribute  this software for
-- any purpose  with or without  fee is hereby granted,  provided that
-- the above copyright notice and this permission notice appear in all
-- copies.
--
-- THE  SOFTWARE IS  PROVIDED "AS  IS"  AND THE  AUTHOR DISCLAIMS  ALL
-- WARRANTIES  WITH  REGARD TO  THIS  SOFTWARE  INCLUDING ALL  IMPLIED
-- WARRANTIES OF  MERCHANTABILITY AND FITNESS.  IN NO EVENT  SHALL THE
-- AUTHOR   BE  LIABLE   FOR   ANY  SPECIAL,   DIRECT,  INDIRECT,   OR
-- CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
-- OF  USE,  DATA  OR  PROFITS,  WHETHER IN  AN  ACTION  OF  CONTRACT,
-- NEGLIGENCE  OR  OTHER  TORTIOUS  ACTION,   ARISING  OUT  OF  OR  IN
-- CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--

import Network.Socket
import System.Environment
import Data.String as String
import Network.Socket
-- import Network.Socket.ByteString as ByteString
import Data.ByteString.Char8 
import Control.Parallel
import Control.Concurrent
import Control.Monad
import Control.Concurrent.Chan
import Control.Concurrent.MVar
import System.Directory
import Data.List

main = do
  args <- getArgs
  sendArgs args

sendArgs args = do
  sock <- socket AF_UNIX Stream defaultProtocol
  connect sock (SockAddrUnix "./test.sock")
  send sock $ Data.List.intercalate " " args
  close sock
