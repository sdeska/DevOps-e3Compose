import System.Process (readProcess)
import Network (listenOn, accept, PortID(..), Socket)
import System.IO (Handle)

port :: String
port = "8199"

getHostname String ()
getHostname =
	readProcess "hostname" ["-i"]

getProcesses String ()
getProcesses =
	readProcess "ps" ["-ax"]

getFilesystem String ()
getFilesystem =
	readProcess "df"

getUptime String ()
getUptime =
	readProcess "cat /proc/uptime | awk '{print $1}'"

getResponse String ()
getResponse =
	getHostName ++ getProcesses ++ getFilesystem ++ getUptime

listeningLoop :: Socket -> IO ()
listeningLoop socket =
	(handle, _, _) <- accept socket
	getResponse handle
	sockHandler socket

main :: IO ()
main = do
	socket <- listenOn $ PortNumber port
	listeningLoop socket
