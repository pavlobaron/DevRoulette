%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the game session server module of DevRoulette.
%% One session server will be started per game.
%% @copyright 2010 Pavlo Baron

-module(dr_session_server).
-behaviour(gen_server).

-export([start_link/2]).
-export([init/1]).
-export([code_change/3]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).

-include("dr_all.hrl").

start_link(Id, SessionId) ->
    gen_server:start_link({local, Id}, ?MODULE, {Id, SessionId}, []).

init(Args) ->
    error_logger:info_report("session server started with Args: "),
    error_logger:info_report(Args),
    {Id, SessionId} = Args,
    State = #state{id = Id, session_id = SessionId},
    {ok, State}.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

handle_call(_Request, _From, State) ->
  Reply = ok,
  {reply, Reply, State}.

handle_cast(stop, State) ->
    dr_session:stop(State#state.session_id),
    {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Shutdown, _State) ->
    ok.
