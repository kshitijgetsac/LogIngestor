-module(log_ingestor).
-export([start/2]).

-define(PORT, 3000).

start(FilePath, ?PORT) ->
    {ok, FileDescriptor} = file:open(FilePath, [read, write]),
    %error_logger:warning_msg("file descriptor ~p",[FileDescriptor]),
    spawn(fun() -> read_logs(FileDescriptor) end),
    start_web_server(?PORT).

read_logs(FileDescriptor) ->
    case file:read_line(FileDescriptor) of
        {ok, Line} ->
            process_log(Line),
            read_logs(FileDescriptor);
        eof ->
            timer:sleep(1000),
            read_logs(FileDescriptor);
        {error, Reason} ->
            io:format("Error reading log: ~p~n", [Reason])
    end.

process_log(Line) ->
    % Process the log line here (e.g., send it to another system)
    io:format("Read log line: ~s~n", [Line]).

start_web_server(Port) ->
    {ok, _} = cowboy:start_http(http_listener_sup, 100, [{port, Port}], [
        {env, [{dispatch, dispatch_rules()}]}
    ]).

dispatch_rules() ->
    cowboy_router:compile([
        {'_', [
            {"/ingest", log_handler, []}
        ]}
    ]).

