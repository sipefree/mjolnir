-module(mjolnir_supervisor).
-behaviour(supervisor).
-export([start/0, start_in_shell_for_testing/0, start_link/1, init/1]).

start() ->
	spawn(fun() ->
			supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg = [])
		end).

start_in_shell_for_testing() ->
	mjolnir_debug:log("Mjolnir Supervisor start in shell..."),
	{ok, Pid} = supervisor:start_link({local,?MODULE}, ?MODULE, _Arg = []),
	unlink(Pid).

start_link(Args) ->
	mjolnir_debug:log("Mjolnir Supervisor starting..."),
	supervisor:start_link({local,?MODULE}, ?MODULE, Args).

init(_Args) ->
		{ok,
			{
				{one_for_one, 1, 60},
				[
					{mjolnir_bot,
					{mjolnir_bot, start_link, []},
					permanent,
					brutal_kill,
					worker,
					[mjolnir_bot]}
				]
			}
		}.
