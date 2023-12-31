-module(log_ingestor_sup).
-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    log_ingestor:start_link(),
    {ok, {{one_for_one, 5, 10}, []}}.