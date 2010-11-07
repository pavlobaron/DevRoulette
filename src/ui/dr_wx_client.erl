%% @author Pavlo Baron <pb@pbit.org>
%% @doc This is the wxErlang based UI client.
%% @copyright 2010 Pavlo Baron

-module(dr_wx_client).
-behavior(dr_gen_client).

-export([init/1]).
-include_lib("wx/include/wx.hrl").

init(Args) ->
    MyWin = wxWindow:new(),
    ok.
