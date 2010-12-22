%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the game session state module of DevRoulette.
%% Two players will be assigned to a session before it will be 'activated'
%% @copyright 2010 Pavlo Baron

-module(dr_session_state).
-behaviour(gen_fsm).

-export([start_link/1]).
-export([init/1]).

start_link(Id) ->
    gen_fsm:start_link({local, Id}, ?MODULE, Id, []).

init(_Args) ->
    error_logger:info_report("state started"),
    {ok, waiting1, []}.
