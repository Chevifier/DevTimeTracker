@tool
extends EditorPlugin

var ui_scene = preload("res://addons/DevTimeTracker/dev_timer_ui.tscn")
var ui_instance
func _enter_tree():
	add_autoload_singleton("Time_Track","res://addons/DevTimeTracker/Time_Track.gd")
	ui_instance = ui_scene.instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BR,ui_instance)
	ui_instance.load_time_elapsed()

#if the editor was saving a scene
func _apply_changes():
	if ui_instance:
		ui_instance.save_time_elapsed()
		

func _input(event):
	ui_instance.resume_session()
	
func _handles(object):
	return true

func _exit_tree():
	remove_control_from_docks(ui_instance)
	remove_autoload_singleton("Time_Track")
	
