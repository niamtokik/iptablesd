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
import Network.Socket hiding (send, sendTo, recv, recvFrom)
import Network.Socket.ByteString
import Data.ByteString as B
import Data.ByteString.Char8 
import Control.Parallel
import Control.Concurrent
import Control.Monad
import Control.Concurrent.Chan
import Control.Concurrent.MVar
import System.Directory
import qualified Data.ByteString.Char8 as C

pathUnixSock :: String -> SockAddr
pathUnixSock path = (SockAddrUnix path)

initUnixSock :: String -> Chan String -> IO ()
initUnixSock path chan = do
  pathExist <- doesFileExist path
  case pathExist of
    True -> existUnixSock path chan
    False -> createUnixSock path chan

existUnixSock path chan = do
  removeFile path
  createUnixSock path chan

createUnixSock :: String -> Chan String -> IO ()
createUnixSock path chan = do
  sock <- socket AF_UNIX Stream defaultProtocol
  bind sock $ pathUnixSock path
  listen sock 1
  forever $ do
    acceptUnixSock sock chan
  removeFile path
  
acceptUnixSock :: Socket -> Chan String -> IO ()
acceptUnixSock sock chan = do
  (conn, _) <- accept sock
  sendToExecutor conn chan
  acceptUnixSock sock chan
  
sendToExecutor :: Socket -> Chan String -> IO ()
sendToExecutor conn chan = do
  msg <- Network.Socket.ByteString.recv conn 1024
  writeChan chan $ C.unpack msg
  close conn

startExecutor chan =
  loopExecutor chan

loopExecutor command chan = do
  msg <- readChan chan
  print $ command ++ " " ++ msg
  loopExecutor command chan

main :: IO ()
main = do
  args <- getArgs
  let path = parseArgs args "-sock" "./test.sock"
      command = parseArgs args "-command" "iptables"
    in do chan <- newChan
          executor <- forkIO $ startExecutor command chan
          listener <- forkIO $ initUnixSock path chan
          print executor
          print listener

parseArgs (x:xs) p d | x == p = Prelude.head xs
parseArgs _ p d = d
