-module(mjolnir_app).
-behaviour(application).
-export([start/2, stop/1]).

start(_Type, StartArgs) ->
	io:format("~n"),
	mjolnir_debug:log("Starting Mjolnir ~p~n", [node()]),
	mjolnir_supervisor:start_link(StartArgs).
stop(_State) ->
	ok.
