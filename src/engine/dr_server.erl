%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the server module of DevRoulette.
%% It is the main supervisor for sessions and connection point for clients.
%% There is one technical server per eingine (thus, per application)
%% @copyright 2010 Pavlo Baron

-module(dr_server).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link(dr_server, []).

init(_Args) ->
    {ok, {{simple_one_for_one, 0, 1},
          [{call, {call, start_link, []},
            temporary, brutal_kill, worker, [call]}]}}.
