extends Control

@export var main_node : Main_menu

@onready var epilogue_button: Button = $Mobile_options/Epilogue

enum {EPILOGUE,PROLOGUE,NEW_GAME,LOAD_GAME,ACHIEVEMENTS,SETTINGS,CONTROLS,CUSTOMIZATION,MODS,CREDITS,EXIT}

func _ready() -> void:
	if GlobalSapphire.game_was_completed == 1:
		epilogue_button.show()

func _on_new_game_pressed() -> void:
	main_node.activate_option(NEW_GAME)

func _on_epilogue_pressed() -> void:
	main_node.activate_option(EPILOGUE)

func _on_load_game_pressed() -> void:
	main_node.activate_option(LOAD_GAME)

func _on_achievements_pressed() -> void:
	main_node.activate_option(ACHIEVEMENTS)

func _on_settings_pressed() -> void:
	main_node.activate_option(SETTINGS)

func _on_controls_pressed() -> void:
	main_node.activate_option(CONTROLS)

func _on_customization_pressed() -> void:
	main_node.activate_option(CUSTOMIZATION)

func _on_credits_pressed() -> void:
	main_node.activate_option(CREDITS)

func _on_prologue_pressed() -> void:
	main_node.activate_option(PROLOGUE)
