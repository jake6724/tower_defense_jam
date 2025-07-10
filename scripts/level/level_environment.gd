class_name LevelEnvironment
extends Node2D

# Child References
@onready var waypoint_manager: WaypointManager = $WaypointManager
@onready var tilemap: TileMapLayer = $TileMapLayer
@onready var base: Base = $Base

# Export vars
@export var level_name: String
@export var initial_gold: int
@export var waves: Array[Wave]