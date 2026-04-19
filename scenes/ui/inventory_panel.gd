extends PanelContainer

@onready var log_label: Label = $MarginContainer/VBoxContainer/Log/LogLabel
@onready var stone_label: Label = $MarginContainer/VBoxContainer/Stone/StoneLabel
@onready var cron_label: Label = $MarginContainer/VBoxContainer/Corn/CronLabel
@onready var milk_label: Label = $MarginContainer/VBoxContainer/Milk/MilkLabel
@onready var tomato_label: Label = $MarginContainer/VBoxContainer/Tomato/TomatoLabel
@onready var egg_label: Label = $MarginContainer/VBoxContainer/Egg/EggLabel


func _ready() -> void:
	InventoryManager.inventory_changed.connect(on_inventory_changed)
	
	
func on_inventory_changed() -> void:
	var inventory: Dictionary = InventoryManager.inventory
	
	if inventory.has("log"):
		log_label.text = str(inventory["log"])
	if inventory.has("stone"):
		stone_label.text = str(inventory["stone"])
	if inventory.has("corn_harvest"):
		cron_label.text = str(inventory["corn_harvest"])
	if inventory.has("milk"):
		milk_label.text = str(inventory["milk"])
	if inventory.has("tomato_harvest"):
		tomato_label.text = str(inventory["tomato_harvest"])
	if inventory.has("egg"):
		egg_label.text = str(inventory["egg"])
	
