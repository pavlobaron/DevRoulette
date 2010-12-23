%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the game session module of DevRoulette.
%% One session wil be started per game, two players will be
%% assigned to a session before it will be 'activated'
%% @copyright 2010 Pavlo Baron

-module(dr_session).
-behaviour(supervisor).

-export([start_link/1]).
-export([init/1, stop/1]).

start_link(Id) ->
    supervisor:start_link({local, Id}, ?MODULE, Id).

make_child_id(Id, Atom) ->
    list_to_atom(atom_to_list(Id) ++ "_" ++ atom_to_list(Atom)).

init(Args) ->
    error_logger:info_report("session started with Args"),
    error_logger:info_report(Args),
    Server = make_child_id(Args, server),
    error_logger:info_report(Server),
    State = make_child_id(Args, state),
    Vm = make_child_id(Args, vm),
    {ok, {{one_for_one, 2, 10}, [
	  {Server,
	   {dr_session_server, start_link, [Server, Args]}, transient, 2000, worker, [dr_session_server]},
	  {State,
	   {dr_session_state, start_link, [State]}, transient, 2000, worker, [dr_session_state]},
	  {Vm,
	   {dr_session_vm, start_link, [Vm]}, transient, 2000, worker, [dr_session_vm]}
    ]}}.

stop(Id) ->
    error_logger:info_report("trying to terminate process: "),
    error_logger:info_report(Id),
    dr_supervisor:end_session(Id).
