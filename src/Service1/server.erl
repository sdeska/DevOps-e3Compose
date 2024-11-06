-module(server).
-export([start/0, do/1]).
-define(PORT, 8199).
-define(SERVICE2_PORT, 8200).

start() ->
	inets:start(),
	case inets:start(httpd, [
		{port, ?PORT},
		{bind_address, "0.0.0.0"},
		{server_name, "local_server"},
		{server_root, "."},
		{document_root, "."},
		{modules, [server]}
	]) of
		{ok, Pid} ->
			io:format("HTTP server started on port ~p with PID ~p~n", [?PORT, Pid]),
			{ok, Pid};
		{error, Reason} ->
			io:format("Failed to start HTTP server with reason: ~p~n", [Reason])
		end.

% do() is automatically called by the httpd server when a HTTP request comes through.
do(_Request) ->
	% Handling only the simple GET requests made with curl, so no need for any logic here.
	io:format("~p received request~n", [self()]),
	{proceed, [{response, {200, get_info()}}]}.

get_info() ->
	LocalInfo = gather_info(local),
	OtherInfo = gather_info(service2),
	LocalInfo ++ OtherInfo.

gather_info(Target) ->
	case Target of
		local ->
			Ip = os:cmd("hostname -i"),
			Processes = os:cmd("ps -ax"),
			Disk = os:cmd("df"),
			Boot = os:cmd("cat /proc/uptime | awk '{print $1}'"),
			io_lib:format("Service~n\t- ~s\t- ~s\t- ~s\t- ~s", [Ip, Processes, Disk, Boot]);
		service2 ->
			case gen_tcp:connect("service2", ?SERVICE2_PORT, [{active, false}, {packet, 0}]) of
				{ok, Socket} ->
					io:format("Successfully connected to Service2 with socket: ~p~n", [Socket]),
					receive_tcp(Socket);
				{error, Reason} ->
					io:format("Connection to Service2 failed with reason: ~p~n", [Reason])
			end;
		_ ->
			"Error: Unknown target"
	end.

receive_tcp(Socket) ->
	case gen_tcp:recv(Socket, 0) of
		{ok, Packet} ->
			io:format("Received packet"),
			io_lib:format("~s", [Packet]);
		{error, Reason2} ->
			io:format("Error while receiving data, reason: ~p~n", [Reason2])
	end.

sleep(Milliseconds) ->
	receive
	after Milliseconds ->
		ok
	end.
