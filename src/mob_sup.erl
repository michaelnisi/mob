-module(mob_sup).

-behaviour(supervisor).

-export([
  start_link/1,
  init/1
]).

-export([
  go/1
]).

-define(NAME, ?MODULE).

start_link(Opts) ->
  supervisor:start_link({local, ?NAME}, ?MODULE, Opts).

sup_flags() -> #{
  strategy => simple_one_for_one,
  intensity => 10,
  period => 5
}.

child_spec({Host, Port}) -> #{
  id => mob_request,
  start => {mob_request, start_link, [{Host, Port}]},
  restart => permanent,
  shutdown => 5000,
  type => worker,
  modules => [mob_request]
}.

init(Opts) ->
  {ok, {sup_flags(), [child_spec(Opts)]}}.

go(F) ->
  supervisor:start_child(?NAME, [F]).
