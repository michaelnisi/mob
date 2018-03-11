-module(mob_sup).

-behaviour(supervisor).

-export([
  start_link/1,
  init/1
]).

-export([
  start_child/1,
  start_children/2
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

start_child(F) ->
  supervisor:start_child(?NAME, [F]).

start_children(_, 0, Children) ->
  Children;
start_children(F, J, Children) ->
  Child = start_child(F),
  start_children(F, J - 1, [Child|Children]).

start_children(F, J) ->
  start_children(F, J, []).

