extends Node

class_name MapGenerator

@export_category("References")
@export var visualMap : GridContainer
@export var tileMap : TileMapLayer

var mapTileRef : PackedScene = preload("res://1_Scenes/1_Objects/map tile.tscn")
var holeTileRef : PackedScene = preload("res://1_Scenes/1_Objects/hole tile.tscn")

func _ready() -> void:
	pass
	
