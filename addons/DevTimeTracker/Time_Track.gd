@tool
extends Node
signal tick
#Change this value

var counter := 0.0
var sec := 0
var min := 0
var hours := 0
var days := 0
var time_passed = ""
var timer_active = true
func _process(delta):
	if timer_active and Engine.is_editor_hint():
		counter += delta
	sec = fmod(counter,60)
	min = fmod(counter, 60*60) / 60
	hours = fmod(fmod(counter, 3600 * 60)/3600, 24)
	days = fmod(counter,12960000) / 86400
	time_passed = "%04d Days \n %02d : %02d : %02d" % [days,hours,min,sec]
