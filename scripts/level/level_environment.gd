class_name LevelEnvironment
extends Node2D

# Child References
@onready var waypoint_manager: WaypointManager = $WaypointManager
@export var waves: Array[Wave]