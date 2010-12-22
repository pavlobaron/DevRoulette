%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the main supervisor module of DevRoulette.
%% @copyright 2010 Pavlo Baron

-module(dr_supervisor).
-behaviour(supervisor).

-export([start_link/1]).
-export([init/1]).
-export([start_session/0]).

start_link(Args) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init(_Args) ->
    ServerSpec = {server,
		  {dr_server, start_link, [dr_server]}, transient, 2000, worker, [dr_server]},
    {ok, {{one_for_one, 2, 10}, [ServerSpec]}}.

get_new_session_id() ->
    Hash = erlang:phash2(make_ref()),
    Id = list_to_atom("session_" ++ integer_to_list(Hash)).

child_spec_from_session_id(Id) ->
    {Id, {dr_session, start_link, [Id]}, transient, 2000, supervisor, [dr_session]}.

start_session() ->
    Id = get_new_session_id(),
    Spec = child_spec_from_session_id(Id),
    Result = supervisor:start_child(?MODULE, Spec),
    error_logger:info_report("supervisor:start_child for session returned: "),
    error_logger:info_report(Result),
    case Result of
	{ok, _} -> {ok, Id};
	{ok, _, _} -> {ok, Id};
	{error, _} -> {error, Id}
    end.
