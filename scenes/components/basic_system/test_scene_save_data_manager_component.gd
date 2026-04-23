class_name TestSceneSaveDataManagerComponent
extends Node

# 延迟到场景稳定后再执行测试加载。
func _ready() -> void:
	call_deferred("load_test_scene")

# 进入测试场景后自动触发读档。
func load_test_scene():
	SaveGameManager.load_game()
