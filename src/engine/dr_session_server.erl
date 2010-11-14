%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the game session server module of DevRoulette.
%% One session server will be started per game.
%% @copyright 2010 Pavlo Baron

-module(dr_session_server).
-behaviour(gen_server).

-export([start_link/1]).
-export([init/1]).
-export([code_change/3]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).

-include("dr_all.hrl").

start_link(Args) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [Args], []).

init(_Args) ->
    error_logger:info_report("server started"),
    process_flag(trap_exit, true),
    {ok, #state{}}.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

handle_call(_Request, _From, State) ->
  Reply = ok,
  {reply, Reply, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Shutdown, _State) ->
    ok.
