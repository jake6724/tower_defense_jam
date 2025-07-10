class_name LevelEnvironment
extends Node2D

# Child References
@onready var waypoint_manager: WaypointManager = $WaypointManager
@onready var tilemap: TileMapLayer = $TileMapLayer
@onready var base: Base = $Base
@export var waves: Array[Wave]