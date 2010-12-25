%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the behavior for DevRoulette UI clients.
%% @copyright 2010 Pavlo Baron

-module(dr_gen_client).
-export([behaviour_info/1]).

behaviour_info(callbacks) ->
    [{init,3}];

behaviour_info(_Other) ->
    undefined.
