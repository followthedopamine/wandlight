extends Node2D

var light_texture = preload("res://sprites/placeholder/WandLightNormal.png")
const GRID_SIZE = 1

@onready var fog = $FogSprite2D
@onready var player = $PlayerCharacterBody2D
@onready var wand_light = $PlayerCharacterBody2D/WandPointLight2D

var display_width = ProjectSettings.get("display/window/size/viewport_width")
var display_height = ProjectSettings.get("display/window/size/viewport_height")

var fog_image = Image.new()
var fog_texture = ImageTexture.new()
var light_image = light_texture.get_image()
var light_dimensions = Vector2(light_texture.get_width(), light_texture.get_height())

func _ready():
	var fog_image_width = display_width/GRID_SIZE
	var fog_image_height = display_height/GRID_SIZE
	fog_image = Image.create(fog_image_width, fog_image_height, false, Image.FORMAT_RGBAH)
	fog_image.fill(Color.BLACK)
	light_image.convert(Image.FORMAT_RGBAH)
	fog.scale *= GRID_SIZE

func update_fog(new_grid_position):
	light_image.resize(light_dimensions.x * wand_light.texture_scale, light_dimensions.y * wand_light.texture_scale)
	var light_offset = Vector2(light_image.get_width()/2, light_image.get_height()/2)
	var light_rect = Rect2(Vector2.ZERO, Vector2(light_image.get_width(), light_image.get_height()))
	
	fog_image.blit_rect(light_image, light_rect, new_grid_position - light_offset)
	update_fog_image_texture()

func update_fog_image_texture():
	fog_texture = ImageTexture.create_from_image(fog_image)
	fog.texture = fog_texture

func _physics_process(delta):
	update_fog(player.position/GRID_SIZE)
