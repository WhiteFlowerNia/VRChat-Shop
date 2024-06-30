extends Button

var refresh = 0

func _on_button_down():
	refresh_Shop()

func _process(delta):
	if Input.is_action_just_pressed("refresh_Button"):
		refresh_Shop()

func refresh_Shop():
	refresh += 1
	print("Refreshed time(s): ", refresh)
