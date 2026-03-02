extends Node2D

@onready var alive: TileMapLayer = $Alive
@onready var dead: TileMapLayer = $Dead
@onready var player: CharacterBody2D = $Player
@onready var level_end: Area2D = $Level_End
@onready var label: Label = $Label
@onready var poison: Area2D = $Poison

var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dead.hide()
	dead.collision_enabled = false
	level_end.body_entered.connect(level_complete)
	poison.body_entered.connect(player_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	level_end.rotate(2*PI*delta)
	if is_dead == true:
		alive.hide()
		alive.collision_enabled = false
		dead.show()
		dead.collision_enabled = true
	else:
		alive.show()
		alive.collision_enabled = true
		dead.hide()
		dead.collision_enabled = false
		

func player_died(body):
	if body == player:
		is_dead = true

func level_complete(body):
	if body == player:
		label.show()
		player.hide()
