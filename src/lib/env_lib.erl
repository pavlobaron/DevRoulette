%% @author Pavlo Baron <pb@pbit.org>
%% @copyright 2010 Pavlo Baron

-module(env_lib).

-export([get_env/2]).

get_env(Area) ->
    Ret = application:get_env(devroulette, Area),
    case Ret of
	{ok, L} -> L;
	_ -> []
    end.

get_env(Area, Key) ->
    [H | _T] = [X || {T, X} <- get_env(Area), T == Key], H.
