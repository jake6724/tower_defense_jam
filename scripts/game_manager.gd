# Autoloader
extends Node

var cell_size: int = 32

# var active_path: PackedVector2Array = [Vector2(32.0, 224.0),Vector2(64.0, 224.0), Vector2(96.0, 224.0), 
# Vector2(128.0, 224.0), Vector2(160.0, 224.0),Vector2(192.0, 224.0), Vector2(224.0, 224.0), 
# Vector2(224.0, 192.0), Vector2(256.0, 192.0), Vector2(288.0, 192.0), Vector2(288.0, 160.0), 
# Vector2(320.0, 160.0), Vector2(320.0, 128.0), Vector2(320.0, 96.0), Vector2(352.0, 96.0),
# Vector2(352.0, 64.0), Vector2(384.0, 64.0)]

func grid_to_world(_pos: Vector2) -> Vector2:
	return _pos * cell_size

func world_to_grid(_pos: Vector2) -> Vector2:
	return floor(_pos / cell_size)
