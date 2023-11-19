-module(log_handler).
-behaviour(cowboy_http_handler).
		
-export([init/3,terminate/3]).
-export([handle/2]).

init(_Transport, Req,_State) ->
    {ok, Req, undefined}.

handle(Req,_State) ->
    error_logger:warning_msg("in handle ~p",[Req]),
    {ok, Body, Req1} = cowboy_req:body(Req),
    error_logger:warning_msg("body~p~n",[Body]),
    case Body of
            Data ->
	    error_logger:warning_msg("data is ~p",[Data]),
            process_received_data(Data),
            Response = cowboy_req:reply(200, [], <<"Log data received">>, Req1),
            {ok, Response, undefined};
           _->
            Response = error,%cowboy_req:reply(400, [], <<"Bad Request">>, Req1)
            {ok, Response, undefined}
    end.

terminate(_Reason, _Req,_State) ->
    ok.

process_received_data(Data) ->
    error_logger:warning_msg("in process receive ~p",[Data]),
    % Process the received log data (e.g., append it to the log file)
    {ok, LogFile} = file:open("/Users/kshitij/Desktop/log_ingestor/src/example.txt", [read,write,append]),
    error_logger:warning_msg("here after recieve~p~n",[LogFile]),
    file:write(LogFile, Data),
    file:write(LogFile,<<"\n">>),
    file:close(LogFile).
