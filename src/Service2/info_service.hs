import System.Process (readProcess)
import Data.ByteString.UTF8 as BS ( fromString )
import Network.Socket
    ( accept,
      bind,
      listen,
      socket,
      Family(AF_INET),
      SockAddr(SockAddrInet),
      Socket,
      SocketType(Stream) )
import Network.Socket.ByteString (sendAll)
import Control.Concurrent (threadDelay)

port :: Int
port = 8200

getHostname :: IO String
getHostname = readProcess "hostname" ["-i"] []

getProcesses :: IO String
getProcesses = readProcess "ps" ["-ax"] []

getFilesystem :: IO String
getFilesystem = readProcess "df" [] []

getUptime :: IO String
getUptime = readProcess "cat" ["/proc/uptime"] []

-- Glues the system information to a specific format for sending to the client
getResponse :: IO [Char]
getResponse = do
  hostStr <- getHostname
  processStr <- getProcesses
  fileStr <- getFilesystem
  upStr <- getUptime
  return $ "Service2:\n\t- " ++ hostStr ++ "\t- " ++ processStr ++ "\t- " ++ fileStr ++ "\t- " ++ upStr

-- Sending a response to a single connected client
respond :: (Socket, SockAddr) -> IO ()
respond (sock, _) = do
  putStrLn "Responding to client"
  response <- getResponse
  sendAll sock (BS.fromString response)

-- Waiting in a loop for connections, serving only one client at a time
listeningLoop :: Socket -> IO ()
listeningLoop sock = do
  putStrLn "Listening..."
  conn <- accept sock
  putStrLn "Received connection"
  respond conn
  listeningLoop sock

-- Creates the listening socket and uses it to call the listeningLoop
main :: IO ()
main = do
  putStrLn "Service2 started"
  sock <- socket AF_INET Stream 0
  bind sock (SockAddrInet (fromIntegral port) 0)
  listen sock 1
  listeningLoop sock
