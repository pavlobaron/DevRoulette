%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the main supervisor module of DevRoulette.
%% @copyright 2010 Pavlo Baron

-module(dr_supervisor).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

-export([start_client/0, end_session/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
    %%FIXME: bring up vm manager

    ServerSpec = {server,
		  {dr_server, start_link, [dr_server]}, transient, 2000, worker, [dr_server]},
    {ok, {{one_for_one, 2, 10}, [ServerSpec]}}.

get_new_session_id() ->
    Hash = erlang:phash2(make_ref()),
    Id = list_to_atom(string:concat("session_", integer_to_list(Hash))).

start_session() ->
    ChildId = get_new_session_id(),
    dr_supervisor_lib:start_dynamic_child(?MODULE, dr_session, start_link,
					  [ChildId], transient, 2000, supervisor, ChildId).

end_session(Id) ->
    dr_supervisor_lib:kill_dynamic_child(?MODULE, Id).

start_client() ->
    L = supervisor:which_children(?MODULE),
    start_client_internal(L).

%%FIXME: here is wx hard-coded -> redesign to configuration
start_client_internal([]) ->
    start_session(),
    start_client();
start_client_internal([H|T]) ->
    {Id, _P, Type, _M} = H,
    case Type of
	supervisor ->
	    Result = dr_session:start_client(Id),
	    error_logger:info_report("start_client returned: "),
	    error_logger:info_report(Result),
	    case Result of
		error ->
		    start_client_internal(T);
		_ -> ok
	    end;
	_ ->  start_client_internal(T)
    end.
