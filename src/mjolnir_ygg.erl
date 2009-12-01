-module(mjolnir_ygg).
-behaviour(gen_server).
-compile(export_all).

%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
-record(odin, {sons}).

start_link() ->
    gen_server:start_link({local, mjolnir_ygg}, ?MODULE, [], []).

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
	mjolnir_debug:log("Mjolnir Yggdrasil (~p) starting ...", [?MODULE]),
	Peers = mjolnir_nodes:node_list(),
	Sons = available_peers(Peers),
	{ok, #odin{sons=Sons}}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------


%% Internal
available_peers(Peers) ->
	lists:foreach(fun(P) -> net_kernel:connect_node(P) end, Peers),
	nodes().

start_peers([]) -> ok.
start_peers([H|T]) -> 
	rpc:call(H, mjolnir_bot, set_yggdrasil, [node()]),
	start_peers(T).
	