-module(mob_app).
-behaviour(application).

-export([
  start/2,
  stop/1
]).

start(_Type, _Args) ->
  Host = application:get_env(mob, host, "localhost"),
  Port = application:get_env(mob, port, 8384),
  mob_sup:start_link({Host, Port}).

stop(_State) ->
	ok.
