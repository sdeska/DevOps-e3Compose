-module(server).
-export([start/0, stop/0, do/1]).
-define(PORT, 8199).

start() ->
	inets:start(),
	case inets:start(httpd, [
		{port, ?PORT},
		{bind_address, "localhost"},
		{server_name, "local_server"},
		{server_root, "."},
		{document_root, "."},
		{modules, [server]}
	]) of
		{ok, Pid} ->
			io:format("HTTP server started on port ~p with PID ~p~n", [?PORT, Pid]),
			{ok, Pid};
		{error, Reason} ->
			io:format("Failed to start HTTP server with reason: ~p~n", [Reason]);
		Unexpected ->
			% Just to catch anything else
			io:format("Unexpected output: ~p~n", [Unexpected])
		end.

stop() ->
	inets:stop(httpd, {{127,0,0,1}, ?PORT}),
	io:format("Server stopped~n").

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
			Ip = os:cmd("hostname -i"), % TODO: Check this in Docker; OS dependent
			Processes = os:cmd("ps -ax"),
			Disk = os:cmd("df"),
			Boot = os:cmd("cat /proc/uptime | awk '{print $1}'"),
			io_lib:format("Service1~n\t- ~s~n\t- ~s~n\t- ~s~n\t- ~s~n", [Ip, Processes, Disk, Boot]);
		service2 ->
			{ok, Socket} = gen_tcp:connect("Service2", ?PORT, [{active, false}, {packet, 2}]),
			case gen_tcp:connect("Service2", ?PORT, [{active, false}, {packet, 2}]) of
				{ok, Socket} ->
					io:format("Successfully connected to Service2 with socket: ~p~n", [Socket]);
				{error, Reason} ->
					io:format("Connection to Service2 failed with reason: ~p~n", [Reason])
			end,
			case gen_tcp:recv(Socket, 0) of
				{ok, Packet} ->
					io:format("Received packet: ~p~n", [Packet]),
					io_lib:format("~s", [Packet]);
				{error, Reason2} ->
					io:format("Error while receiving data, reason: ~p~n", [Reason2])
			end;
		_ ->
			"Error"
	end.
