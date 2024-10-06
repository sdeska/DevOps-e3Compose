import System.Process (readProcess)
import Data.ByteString.UTF8 as BS
import Network.Socket
import Network.Socket.ByteString (sendAll)

port :: String
port = "8199"

getHostname =
  readProcess "hostname" ["-i"] []

getProcesses =
  readProcess "ps" ["-ax"] []

getFilesystem =
  readProcess "df" [] []

getUptime =
  readProcess "cat /proc/uptime | awk '{print $1}'" [] []

getResponse = do
  hostStr <- getHostname
  processStr <- getProcesses
  fileStr <- getFilesystem
  upStr <- getUptime
  return $ hostStr ++ processStr ++ fileStr ++ upStr

listeningLoop :: Socket -> IO ()
listeningLoop sock = do
  conn <- accept sock
  respond conn
  listeningLoop sock

respond :: (Socket, SockAddr) -> IO ()
respond (sock, _) = do
  responseString <- getResponse
  sendAll sock (BS.fromString responseString)

main :: IO ()
main = do
  sock <- socket AF_INET Stream 0
  bind sock (SockAddrInet (read port) 0)
  listen sock 1
  listeningLoop sock
