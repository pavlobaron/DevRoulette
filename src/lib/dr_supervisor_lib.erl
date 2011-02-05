%% @author Pavlo Baron <pb@pbit.org>
%% @copyright 2010 Pavlo Baron

-module(supervisor_lib).

-export([start_dynamic_child/8, make_child_id/2, kill_dynamic_child/2]).

new_child_spec(Id, M, F, A, Restart, Time, Type) ->
    {Id, {M, F, A}, Restart, Time, Type, [M]}.

make_child_id(Id, Atom) ->
    list_to_atom(string:concat(string:concat(atom_to_list(Id), "_"), atom_to_list(Atom))).

start_dynamic_child(Id, M, F, A, Restart, Time, Type, ChildId) ->
    Spec = new_child_spec(ChildId, M, F, A, Restart, Time, Type),
    Result = supervisor:start_child(Id, Spec),
    error_logger:info_report("supervisor:start_child returned: "),
    error_logger:info_report(Result),
    case Result of
	{ok, _} -> {ok, Id};
	{ok, _, _} -> {ok, Id};
	{error, _} -> {error, Id}
    end.

kill_dynamic_child(Id, ChildId) ->
    error_logger:info_report("trying to terminate child: "),
    error_logger:info_report(ChildId),
    Terminate = supervisor:terminate_child(Id, ChildId),

    %%FIXME: terminate doesn't return immidiately -> fix it to loop
    %%and to wait for the child process to be killed

    error_logger:info_report("child termination returned: "),
    error_logger:info_report(Terminate),
    Delete = supervisor:delete_child(Id, ChildId),
    error_logger:info_report("spec delete returned: "),
    error_logger:info_report(Delete).
