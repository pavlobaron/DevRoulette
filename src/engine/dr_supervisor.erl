%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the supervisor module of DevRoulette.
%% It is the main supervisor for sessions and connection point for clients.
%% There is one technical server per eingine (thus, per application)
%% @copyright 2010 Pavlo Baron

-module(dr_supervisor).
-behaviour(supervisor).
-export([start_link/1]).
-export([init/1]).

start_link(Args) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init(Args) ->
    {ok, {{one_for_one, 2, 10}, [
	  {session, {dr_session, start_link, [Args]}, transient, 2000, supervisor, [dr_session]}
    ]}}.
