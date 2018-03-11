-module(mob_app).
-behaviour(application).

-export([
  start/2,
  stop/1
]).

%% API
-export([go/1]).

start(_Type, _Args) ->
  Host = application:get_env(mob, host, "localhost"),
  Port = application:get_env(mob, port, 8384),
  mob_sup:start_link({Host, Port}).

go(StreamFun) ->
  mob_sup:go(StreamFun).

stop(_State) ->
	ok.
