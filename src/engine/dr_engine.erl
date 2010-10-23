%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the main module of the DevRoulette engine.
%% It starts the main supervisor and does all the wiring of the managing components
%% @copyright 2010 Pavlo Baron

-module(dr_engine).
-behaviour(application).
-export([start/2, stop/1]).

start(_Type, _Args) ->
    dr_server:start_link().

stop(_State) ->
    ok.
