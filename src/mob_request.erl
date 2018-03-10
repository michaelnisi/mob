-module(mob_request).
-behaviour(gen_statem).

-export([start_link/2]).

-export([
  terminate/3,
  code_change/4,
  init/1,
  callback_mode/0
]).

-export([
  connecting/3,
  requesting/3,
  receiving/3
]).

-record(state, {
  protocol,
  host,
  port,
  connection,
  stream,
  streamFun
}).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

%% API

start_link({Host, Port}, F) ->
  gen_statem:start_link(?MODULE, {Host, Port, F}, []).

%% Mandatory Callbacks

connect(Host, Port) ->
  {ok, ConnPid} = gun:open(Host, Port),
  #state{
    host=Host,
    port=Port,
    connection=ConnPid
  }.

init({Host, Port, StreamFun}) ->
  process_flag(trap_exit, true),
  State = connect(Host, Port),
  {ok, connecting, State#state{streamFun=StreamFun}}.

terminate(_Reason, _StateName, State) ->
  C = State#state.connection,
  gun:shutdown(C).

code_change(_OldVsn, StateName, State, _Extra) ->
  {ok, StateName, State}.

callback_mode() -> state_functions.

%% State Callbacks

request(State) ->
  C = State#state.connection,
  F = State#state.streamFun,
  S = F(C),
  Next = State#state{stream=S},
  {next_state, requesting, Next}.

maybe_cancel(C, S) ->
  case rand:uniform(500) of
    1 -> gun:cancel(C, S);
    _ -> no
  end.

connecting(info, {gun_up, _, _}, State) ->
  request(State).

requesting(info, {gun_response, _, _, fin, _, _}, State) ->
  {next_state, requesting, State};
requesting(info, {gun_response, C, S, nofin, _, _}, State) ->
  case maybe_cancel(C, S) of
    ok -> {stop, normal, State};
    _ -> {next_state, receiving, State}
  end.

receiving(info, {gun_data, _, _, nofin, _}, State) ->
  {next_state, receiving, State};
receiving(info, {gun_data, _, _, fin, _}, State) ->
  Time = rand:uniform(5000) + 1000,
  timer:sleep(Time),
  request(State).
