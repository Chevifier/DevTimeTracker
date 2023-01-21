@tool
extends Control
@onready var devtimeres := load("res://addons/DevTimeTracker/DevTime.tres")
var user_paused = false
const inactivity_timeout = 30

func _ready():
	load_time_elapsed()
	set_project_name(ProjectSettings.get_setting("application/config/name","No App Name"))
	get_processes_runnning()

var search_processes = ["Godot", "Blender", "asprite"]
func get_processes_runnning():
	var result = []
	var process_present = false
	if OS.get_name() == "Linux":
		for process in search_processes:
			process_present = search_linux_processes(process)
			if process_present:
				break
	elif OS.get_name() == "Windows":
		for process in search_processes:
			process_present = search_windows_processes(process)
			if process_present:
				break
	return process_present
	
func search_linux_processes(process:String):
	var result = []
	var e
	e = OS.execute("pgrep", ["-l", process],result)
	if result[0].contains(process):
		return true
	return false
func search_windows_processes(process:String):
	var result = []
	var e
	e = OS.execute("tasklist",["/FI", "imagename", "eq", process],result)
	if result[0].contains(process):
		return true
	return false
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$vb/vb/Time_Elapsed.text = Time_Track.time_passed
	
	
func set_project_name(project_name):
	$vb/vb/Project_name.text = project_name
	
func load_time_elapsed():
	Time_Track.counter =devtimeres.time_elapsed
	
func save_time_elapsed():
	devtimeres.time_elapsed = Time_Track.counter
	devtimeres.sec = Time_Track.sec
	devtimeres.minutes = Time_Track.min
	devtimeres.hours = Time_Track.hours
	devtimeres.days = Time_Track.days

func _on_warn_1_confirmed():
	$WARN2.popup_centered()

func _on_reset_pressed():
	$WARN1.popup_centered()

func _on_warn_2_confirmed():
	Time_Track.counter = 0.0

func resume_session():
	if user_paused:
		return
	$NoActivityPauseTimer.start(inactivity_timeout)
	$PAUSED_LABEL.hide()
	Time_Track.timer_active = true
func _on_no_activity_pause_timer_timeout():
	if user_paused:
		return
	Time_Track.timer_active = false
	$PAUSED_LABEL.show()


func _on_pause_toggled(button_pressed):
	if user_paused == false:
		Time_Track.timer_active = false
		user_paused = true
	else:
		user_paused = false
		resume_session()
