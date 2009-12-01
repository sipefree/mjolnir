-module(mjolnir_bot).
-behaviour(gen_server).
-compile(export_all).

%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
-record(thor, {yggdrasil, queue}).

start_link() ->
    gen_server:start_link({local, mjolnir_bot}, ?MODULE, [], []).

set_yggdrasil(Node) ->
	gen_server:call(?MODULE, {set_yggdrasil, Node}, 20000).

do_battle(Module, Function, Args) ->
	gen_server:call(?MODULE, {do_battle, Module, Function, Args}).
 
%%====================================================================
%% gen_server callbacks
%%====================================================================

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([]) ->
	process_flag(trap_exit, true),
	mjolnir_debug:log("Mjolnir Bot (~p) starting ...", [?MODULE]),
	{ok, #thor{yggdrasil=false, queue=[]}}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------

handle_call({set_yggdrasil, Node}, _From, State) ->
	mjolnir_debug:log("Greatfather Yggdrasil has arrived! ~p~n", [Node]),
	{noreply, State#thor{yggdrasil=Node}};

handle_call({do_battle, Module, Function, Args}, _From, State) ->
	mjolnir_debug:log("Doing battle with ~p:~p for ~p~n", [Module, Function, Args]),
	Result = apply(Module, Function, Args),
	{reply, Result, State}.