module SmokeTest
  ( smokeTest
  ) where

import qualified Data.ByteString               as B
import           Network.Simple.TCP

{-
https://protohackers.com/problem/0
Deep inside Initrode Global's enterprise management framework lies a component that writes data to a server and expects to read the same data back. (Think of it as a kind of distributed system delay-line memory). We need you to write the server to echo the data back.

Accept TCP connections.

Whenever you receive data from a client, send it back unmodified.

Make sure you don't mangle binary data, and that you can handle at least 5 simultaneous clients.

Once the client has finished sending data to you it shuts down its sending side. Once you've reached end-of-file on your receiving side, and sent back all the data you've received, close the socket so that the client knows you've finished. (This point trips up a lot of proxy software, such as ngrok; if you're using a proxy and you can't work out why you're failing the check, try hosting your server in the cloud instead).

Your program will implement the TCP Echo Service from RFC 862.
-}


smokeTest :: String -> String -> IO ()
smokeTest host port = do
  putStrLn $ "Listening on " ++ host ++ ":" ++ port
  serve (Host host) port handler

handler :: (Socket, SockAddr) -> IO ()
handler (socket, addr) = do
  let printableAddr = show addr
  putStrLn $ "TCP connection established from " ++ printableAddr
  loop socket
  putStrLn $ "Closing connection from " ++ printableAddr

receive :: Socket -> (Maybe B.ByteString) -> IO ()
receive _      Nothing      = return ()
receive socket (Just bytes) = do
  send socket bytes
  loop socket

batchSize = 4096
loop :: Socket -> IO ()
loop socket = do
  bytes <- recv socket batchSize
  receive socket bytes
