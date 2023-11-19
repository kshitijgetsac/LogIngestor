-module(filter_handler).
-behaviour(cowboy_http_handler).

-export([init/3, handle/2,terminate/3]).

init(_Transport, Req,_State) ->
    {ok, Req, undefined_state}.
terminate(_Reason,_Req,_State)->
	ok.

handle(Req, _State) ->
    {Method, Req2} = cowboy_req:method(Req),
    {Params, _Req3} = cowboy_req:qs_vals(Req2),
    error_logger:warning_msg("params and method is ~p",[{Method,Params}]),
    {_Cr,SearchFor} = lists:keyfind(<<"criteria">>,1,Params),
    {_Bo,SearchText} = lists:keyfind(<<"value">>,1,Params),
    error_logger:warning_msg("params and method log2 ~p",[{SearchFor,SearchText}]),
    FilteredLogs = filter_log_file(SearchFor,SearchText),  % Implement filter logic here
    {ok, Req4} = cowboy_req:reply(200, [], FilteredLogs, Req2),
    {ok, Req4,undefined}.

filter_log_file(Criteria,Value)->
   log_processor:filter_logs_with_foldl(Criteria,Value).
 