-module(mjolnir_debug).
-compile(export_all).

log(Text) ->
	log(Text, []).
log(Text, Replaces) ->
	{{Year,Month,Day},{Hour,Minutes,Seconds}} = erlang:localtime(),
	Formatted = io_lib:format(Text, Replaces),
	io:format("[~p-~p-~p ~p:~p:~p ~s~n", [Year, Month, Day, Hour, Minutes, Seconds, Formatted]).
