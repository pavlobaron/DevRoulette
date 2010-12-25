%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the server module of DevRoulette.
%% It is the initial connection point for clients which actually creates sessions.
%% After a session has been completely established, the session server will be used
%% for further communication.
%% There is one server per engine (thus, per application)
%% @copyright 2010 Pavlo Baron

-module(dr_server).
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
    gen_server:start_link({local, ?MODULE}, ?MODULE, Args, []).

init(Args) ->
    error_logger:info_report("main server started with Args = "),
    error_logger:info_report(Args),
    process_flag(trap_exit, true),
    {ok, #server_state{}}.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

handle_call(new_client, _From, State) ->
    Result = dr_supervisor:start_client(),
    {reply, Result, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Shutdown, _State) ->
    ok.
