%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the environment lib of DevRoulette.
%% @copyright 2010 Pavlo Baron

-module(dr_env_lib).

-export([get_env/2]).

get_env(Area) ->
    Ret = application:get_env(devroulette, Area),
    case Ret of
	{ok, L} -> L;
	_ -> []
    end.

get_env(Area, Key) ->

error_logger:info_report(get_env(Area)),

    [H | _T] = [X || {T, X} <- get_env(Area), T == Key], H.
