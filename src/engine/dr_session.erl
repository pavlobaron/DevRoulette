%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the game session module of DevRoulette.
%% One session wil be started per game, two players will be
%% assigned to a session before it will be 'activated'
%% @copyright 2010 Pavlo Baron

-module(dr_session).
-behaviour(supervisor).

-export([start_link/1]).
-export([init/1]).

start_link(Args) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init(Args) ->
    error_logger:info_report("session started"),
    {ok, {{one_for_one, 2, 10}, [
	  {server, {dr_session_server, start_link, [Args]}, transient, 2000, worker, [dr_session_server]},
	  {state, {dr_session_state, start_link, [Args]}, transient, 2000, worker, [dr_session_state]},
	  {vm, {dr_session_vm, start_link, [Args]}, transient, 2000, worker, [dr_session_vm]}
    ]}}.
