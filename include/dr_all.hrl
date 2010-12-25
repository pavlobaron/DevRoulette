%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the header including all records and macros of DevRoulette.
%% @copyright 2010 Pavlo Baron

-record(session_server_state, {
	  session_id,
	  id
        }).

-record(server_state, {
    nada
        }).

-record(session_client_state, {
	  id,
	  server
        }).

-record(session_state_state, {
    nada
        }).

-record(session_vm_state, {
    nada
        }).
