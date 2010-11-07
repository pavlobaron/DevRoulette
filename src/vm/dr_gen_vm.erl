%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the behavior for DevRoulette VMs.
%% @copyright 2010 Pavlo Baron

-module(dr_gen_vm).
-export([behaviour_info/1]).

behaviour_info(callbacks) ->
    [{init,1}];

behaviour_info(_Other) ->
    undefined.
