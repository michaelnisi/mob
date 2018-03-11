%% mob - stress http apis

-module(mob).

-export([
  start/0,
  start/2,
  stop/0
]).

start() ->
  {ok, _} = application:ensure_all_started(gun),
  application:start(?MODULE).

stop() ->
  ok = application:stop(?MODULE),
  application:stop(gun).

start(Host, Port) ->
  ok = application:set_env(mob, host, Host),
  ok = application:set_env(mob, port, Port),
  start().
