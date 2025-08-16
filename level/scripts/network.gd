extends Node

const SERVER_ADDRESS: String = "127.0.0.1"
const SERVER_PORT: int = 8080
const MAX_PLAYERS : int = 10

var players := {}
var player_info := {
	"nick" : "host",
	"skin" : Character.SkinColor.BLUE
}

signal player_connected(peer_id: int, player_info: Dictionary)
signal server_disconnected

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit(0)
		
func _ready() -> void:
	multiplayer.server_disconnected.connect(_on_connection_failed)
	multiplayer.connection_failed.connect(_on_server_disconnected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.connected_to_server.connect(_on_connected_ok)

func start_host(nickname: String, skin_color_str: String, _host_as_player: bool) -> void:
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = peer
	
	player_info["nick"] = nickname
	player_info["skin"] = skin_str_to_e(skin_color_str) 
	players[1] = player_info
	player_connected.emit(1, player_info)
	
func join_game(nickname: String, skin_color_str: String, address: String = SERVER_ADDRESS) -> void:
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(address, SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	
	if !nickname:
		nickname = "Player_" + str(multiplayer.get_unique_id())

	var skin_enum : Character.SkinColor = skin_str_to_e(skin_color_str)

	player_info["nick"] = nickname
	player_info["skin"] = skin_enum 
	
func _on_connected_ok()	-> void:
	var peer_id : int = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)
	
func _on_player_connected(id: int) -> void:
	_register_player.rpc_id(id, player_info)
	
@rpc("any_peer", "reliable")
func _register_player(new_player_info: Dictionary) -> void:
	var new_player_id : int = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)
	#print("debug function _register_player on Network.gd: ", players, "\n")

func _on_player_disconnected(id: int) -> void:
	players.erase(id)

func _on_connection_failed() -> void:
	multiplayer.multiplayer_peer = null

func _on_server_disconnected() -> void:
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()

func skin_str_to_e(s: String) -> Character.SkinColor:
	match s.to_lower():
		"blue": return Character.SkinColor.BLUE
		"yellow": return Character.SkinColor.YELLOW
		"green": return Character.SkinColor.GREEN
		"red": return Character.SkinColor.RED
		_: return Character.SkinColor.BLUE
	
