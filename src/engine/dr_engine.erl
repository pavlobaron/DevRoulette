%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the main module of the DevRoulette engine.
%% It starts the main supervisor and does all the wiring of the managing components
%% @copyright 2010 Pavlo Baron (GPL)

-module(engine.dr_engine).
-behaviour(application).
-export([start/2, stop/1]).

start(_Type, _Args) ->
    self. %nonsense return, just as dummy here for further development

stop(_State) ->
    ok.
