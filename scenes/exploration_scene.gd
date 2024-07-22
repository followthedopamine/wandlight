extends Node2D

const LIGHT_TEXTURE = preload("res://sprites/placeholder/Light.png")
const GRID_SIZE = 16

@onready var fog = $Fog
@onready var player = $PlayerCharacterBody2D

var display_width = ProjectSettings.get("display/window/size/viewport_width")
var display_height = ProjectSettings.get("display/window/size/viewport_height")

var fog_image = Image.new()
var fog_texture = ImageTexture.new()
var light_image = LIGHT_TEXTURE.get_image()
var light_offset = Vector2(LIGHT_TEXTURE.get_width()/2, LIGHT_TEXTURE.get_height()/2)

func _ready():
	var fog_image_width = display_width/GRID_SIZE
	var fog_image_height = display_height/GRID_SIZE
	fog_image = Image.create(fog_image_width, fog_image_height, false, Image.FORMAT_RGBAH)
	fog_image.fill(Color.BLACK)
	light_image.convert(Image.FORMAT_RGBAH)
	fog.scale *= GRID_SIZE

func update_fog(new_grid_position):
	var light_rect = Rect2(Vector2.ZERO, Vector2(light_image.get_width(), light_image.get_height()))
	fog_image.blend_rect(light_image, light_rect, new_grid_position - light_offset)
	update_fog_image_texture()

func update_fog_image_texture():
	fog_texture = ImageTexture.create_from_image(fog_image)
	fog.texture = fog_texture

func _physics_process(delta):
	update_fog(player.position/GRID_SIZE)
