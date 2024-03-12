extends Area3D



@export var label_text : String
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	get_node("Label3D").text = label_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
