%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the wxErlang based UI client.
%% @copyright 2010 Pavlo Baron

-module(dr_wx_client).
-behavior(dr_gen_client).

-export([init/3, start_link/2]).

-include_lib("wx/include/wx.hrl").
-include("dr_all.hrl").

-define(EXIT, ?wxID_EXIT).

start_link(Id, Server) ->
    {Result, Pid} = proc_lib:start_link(?MODULE, init, [self(), Id, Server]),
    case Result of
	ok ->
	    case register(Id, Pid) of
		true ->
		    {ok, Pid};
		_ ->
		    {error, noregister}
	    end;
	Whatever -> {Whatever, Pid}
    end.

init(Pid, Id, Server) ->
    %%REDISIGN: here, the code for the client must be pushed over to the client machine and
    %%run there
    proc_lib:init_ack(Pid, {ok, self()}),

    wx:new(),
    Win = wxFrame:new(wx:null(), ?wxID_ANY, "DevRoulette"),
    setup_win(Win),
    wxFrame:show(Win),
    loop(Win, #session_client_state{id = Id, server = Server}),
    wx:destroy().

setup_win(Win) ->
    Menu = wxMenuBar:new(),
    File = wxMenu:new(),
    wxMenu:append(File, ?EXIT, "Quit"),
    wxMenuBar:append(Menu, File, "&File"),
    wxFrame:setMenuBar(Win, Menu),
    wxFrame:connect(Win, command_menu_selected),
    wxFrame:connect(Win, close_window).

loop(Win, State) ->
    receive
	#wx{id=?EXIT, event=#wxCommand{type=command_menu_selected}} ->
	    wxWindow:close(Win, []),
	    gen_server:cast(State#session_client_state.server, {kill_client,
								State#session_client_state.id})
    end.
