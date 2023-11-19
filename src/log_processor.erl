-module(log_processor).
-export([filter_logs_with_foldl/2]).
-export([strip/1,parse_json/1]).

filter_logs_with_foldl(Criteria,Value) ->
    {ok, InputDevice} = file:open("/Users/kshitij/Desktop/log_ingestor/src/example.txt", [read]),
    {ok, OutputDevice} = file:open("/Users/kshitij/Desktop/log_ingestor/src/output.txt", [write]),
    process_logs(InputDevice, OutputDevice),
    file:close(InputDevice),
    file:close(OutputDevice).

process_logs(InputDevice, OutputDevice) ->
    Logs = read_logs(InputDevice),
    FilteredLogs = lists:filter(fun filter_log/1, Logs),
    write_logs(OutputDevice, FilteredLogs).

read_logs(InputDevice) ->
    case file:read_file("/Users/kshitij/Desktop/log_ingestor/src/example.txt") of
        {ok, Data} ->
	    if Data == "{" ->
	       Lines = <<"">>;
	    true->
                Lines = string:split(binary_to_list(Data), "\n")
            end,
	    error_logger:warning_msg("lines are~p",[Lines]),
            lists:map(fun parse_json/1, Lines);
        {error, Reason} ->
            io:format("Error reading file: ~p~n", [Reason]),
            []
    end.

parse_json(Line) ->
    try jsx:decode(Line) of
        {ok, Parsed} -> Parsed
    catch
        error:badarg -> jsx:decode(fix_escaped_quotes(Line))
    end.

fix_escaped_quotes(Line) ->
    String = binary_to_list(Line),
    Regex = re:compile("\\\\\""),
    re:replace(String, Regex, "\"", [global, {return, list}]).

write_logs(_, []) -> ok;
write_logs(OutputDevice, [Log | RestLogs]) ->
    LogStr = jsx:encode(Log) ++ "\n",
    file:write(OutputDevice, LogStr),
    write_logs(OutputDevice, RestLogs).


filter_log(Log) ->
    true.

strip(Line) ->
    string:strip(Line, both, $\n).

