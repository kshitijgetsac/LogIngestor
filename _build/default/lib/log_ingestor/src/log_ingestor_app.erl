-module(log_ingestor_app).
-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_Type, _Args) ->
    FilePath = "/Users/kshitij/log_ingestor/src/example.txt", % Specify your log file path here
    Port = 3000,
    log_ingestor:start(FilePath, Port),
    {ok,[]} = application:ensure_all_started(cowboy).
    %log_ingestor_sup:start_link().

stop(_State) ->
    ok.
