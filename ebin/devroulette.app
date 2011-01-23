{application, devroulette,
 [{description, "DevRoulette - a game for geeks"},
  {vsn, "0.1"},
  {modules, []},
  {registered, []},
  {applications, [kernel, stdlib]},
  {mod,
	{dr_engine, []}
  },
  {env, [
	{dr_session, [
		     {client, "dr_wx_client"}
		     ]},
	{dr_vm_server, [
		       {vm, "dr_virtualbox_vm"},
		       {prog, "c:/program files/oracle/virtualbox/vboxmanage.exe"},
		       {template, "dr_vb_template"},
		       {params_start, "startvm --type headless"},
		       {params_clone, "clonehd"}
		       ]}
  ]}]}.