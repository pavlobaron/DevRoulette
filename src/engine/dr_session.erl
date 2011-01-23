%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the game session module of DevRoulette.
%% One session wil be started per game, two players will be
%% assigned to a session before it will be 'activated'
%% @copyright 2010 Pavlo Baron

-module(dr_session).
-behaviour(supervisor).

-export([start_link/1]).
-export([init/1, stop/1, start_client/1, kill_client/2]).

start_link(Id) ->
    supervisor:start_link({local, Id}, ?MODULE, Id).

init(Args) ->
    error_logger:info_report("session started with Args"),
    error_logger:info_report(Args),
    Server = dr_supervisor_lib:make_child_id(Args, server),
    State = dr_supervisor_lib:make_child_id(Args, state),
    Vm = dr_supervisor_lib:make_child_id(Args, vm),
    {ok, {{one_for_one, 2, 10}, [
	  {Server,
	   {dr_session_server, start_link, [Server, Args]}, transient, 2000, worker, [dr_session_server]},
	  {State,
	   {dr_session_state, start_link, [State]}, transient, 2000, worker, [dr_session_state]},
	  {Vm,
	   {dr_session_vm, start_link, [Vm]}, transient, 2000, worker, [dr_session_vm]}
    ]}}.

stop(Id) ->
    dr_supervisor:end_session(Id).

%% FIXME: for the first draft, the clients will be started
%% on the local machine. In the real world implementation,
%% clients have to be started on remote client nodes
start_client(Id) ->
    [_S, _A, _Sup, {workers, Workers}] = supervisor:count_children(Id),
    case Workers < 5 of
	true ->
	    ChildAtom = dr_supervisor_lib:make_child_id(Id, client),
	    ChildId = list_to_atom(string:concat(
				     string:concat(atom_to_list(ChildAtom), "_"),
				     integer_to_list(Workers - 2))),
	    dr_supervisor_lib:start_dynamic_child(Id,
						  list_to_atom(dr_env_lib:get_env(dr_session, client)),
						  start_link,
						  [ChildId,
						   dr_supervisor_lib:make_child_id(Id, server)],
						  transient, 2000, worker, ChildId);
    	false ->
	    error_logger:info_report("only two clients are allowed per session"),
	    error
    end.

kill_client(Id, ChildId) ->
    dr_supervisor_lib:kill_dynamic_child(Id, ChildId),
    [_S, _A, _Sup, {workers, Workers}] = supervisor:count_children(Id),
    case Workers < 4 of
	true ->
	    stop(Id);
	_ -> ok
    end.
