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
-record(thor, {sons, yggdrasil}).

start_link() ->
	mjolnir_debug:log("Durr"),
    gen_server:start_link({local, mjolnir_bot}, ?MODULE, [], []).

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
	Peers = mjolnir_nodes:node_list(),
	SonsOfYggdrasil = available_peers(Peers),
	mjolnir_debug:log("Discovered peers: ~p", [SonsOfYggdrasil]),
	{ok, #thor{sons=SonsOfYggdrasil, yggdrasil=false}}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------

handle_call({add_peer, Node}, _From, State) ->
	Node ! {added_peer, self()}.


%%% Internal
yggdrasil(Peers) ->
	[H|T] = lists:sort(Peers),
	yggdrasil(H, T).
	
yggdrasil(H, []) ->
	Self = node(),
	case H of
		Self ->
			Self;
		_ ->
			case net_kernel:connect_node(H) of 
				true ->
					H;
				false ->
					false
			end
	end;
	
yggdrasil(H, T) ->
	Self = node(),
	case H of
		Self ->
			Self;
		_ ->
			case net_kernel:connect_node(H) of 
				true ->
					H;
				false ->
					[H2, T2] = T,
					yggdrasil(H2, T2)
			end
	end.

available_peers(Peers) ->
	lists:foreach(fun(P) -> net_kernel:connect_node(P) end, Peers),
	nodes().