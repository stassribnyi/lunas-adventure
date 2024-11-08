# This is the main script of the game. It manages the current map and some other stuff.
extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name Game

const SaveManager = preload("res://addons/MetroidvaniaSystem/Template/Scripts/SaveManager.gd")
const SAVE_PATH = "user://example_save_data.sav"

# The game starts in this map. Note that it's scene name only, just like MetSys refers to rooms.
@export var starting_map: String

@onready var pause_menu: Control = $UI/PauseMenu
@onready var vignette_overlay: Sprite2D = $Vignette
@onready var ambient_sound: AudioStreamPlayer2D = $Player/Ambient

# Number of collected collectibles. Setting it also updates the counter.
var collectibles: int:
	set(count):
		collectibles = count
		%CollectibleCount.text = "%d/15" % count

var kills: int:
	set(value):
		kills = value

# The coordinates of generated rooms. MetSys does not keep this list, so it needs to be done manually.
var generated_rooms: Array[Vector3i]
# The typical array of game events. It's supplementary to the storable objects.
var events: Array[String]
# For Custom Runner integration.
var custom_run: bool
var is_cutscene_running: bool

func _ready() -> void:
	# A trick for static object reference (before static vars were a thing).
	get_script().set_meta(&"singleton", self)
	# Make sure MetSys is in initial state.
	# Does not matter in this project, but normally this ensures that the game works correctly when you exit to menu and start again.
	MetSys.reset_state()
	# Assign player for MetSysGame.
	set_player($Player)

	if FileAccess.file_exists(SAVE_PATH):
		# If save data exists, load it using MetSys SaveManager.
		var save_manager := SaveManager.new()
		save_manager.load_from_text(SAVE_PATH)
		# Assign loaded values.
		collectibles = save_manager.get_value("collectible_count")
		kills = save_manager.get_value("kills_count")
		generated_rooms.assign(save_manager.get_value("generated_rooms"))
		events.assign(save_manager.get_value("events"))
		player.abilities.assign(save_manager.get_value("abilities"))
		player.inventory.assign(save_manager.get_value("inventory"))

			# currently we have ability first upgrade, therefore we have to map abilities count to evolutions
		player.evolve(player.abilities.size() + 1) # we have 1 defautl, 2 second evolution, 3 final one

		if not custom_run:
			var loaded_starting_map: String = save_manager.get_value("current_room")
			if not loaded_starting_map.is_empty(): # Some compatibility problem.
				starting_map = loaded_starting_map
	else:
		# If no data exists, set empty one.
		MetSys.set_save_data()
	
	# Initialize room when it changes.
	room_loaded.connect(init_room, CONNECT_DEFERRED)
	# Load the starting room.
	load_room(starting_map)
	
	# Find the save point and teleport the player to it, to start at the save point.
	var reset_position = get_player_position_at_start()
	print('Game:_ready() -> position on room load: {0}, player position: {1}'.format([reset_position, player.position]))
	player.position = reset_position if reset_position != null else player.position

	# Reset position tracking (feature specific to this project).
	reset_map_starting_coords.call_deferred()
	# Add module for room transitions.
	add_module("RoomTransitions.gd")

func get_player_position_at_start():
	var start := map.get_node_or_null(^"SavePoint")
	if start and not custom_run:
		return start.position

func _process(delta: float) -> void:
	var viewport = get_viewport()
	var center := viewport.get_camera_2d().get_screen_center_position()
	vignette_overlay.position = center
	
	if is_cutscene_running:
		$UI.hide()
	else:
		$UI.show()

# Returns this node from anywhere.
static func get_singleton() -> Game:
	return (Game as Script).get_meta(&"singleton") as Game

# Save game using MetSys SaveManager.
func save_game():
	var save_manager := SaveManager.new()
	save_manager.set_value("collectible_count", collectibles)
	save_manager.set_value("kills_count", kills)
	save_manager.set_value("generated_rooms", generated_rooms)
	save_manager.set_value("events", events)
	save_manager.set_value("current_room", MetSys.get_current_room_name())
	save_manager.set_value("abilities", player.abilities)
	save_manager.set_value("inventory", player.inventory)
	save_manager.save_as_text(SAVE_PATH)

func reset_map_starting_coords():
	$UI/MapWindow.reset_starting_coords()

func init_room():
	MetSys.get_current_room_instance().adjust_camera_limits($Player/Camera2D)
	var reset_position = get_player_position_at_start()
	print('Game:init_room() -> position on room load: {0}, player position: {1}'.format([reset_position, player.position]))
	if reset_position != null:
		player.on_enter(reset_position)
	else:
		player.on_enter()

func toggle_ambient(enable = true) -> void:
	if not ambient_sound.playing or enable:
		ambient_sound.play()
	else:
		ambient_sound.stop()
