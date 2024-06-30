extends Control

@onready var itemSCN = preload("res://item.tscn")
@onready var deathSCN = preload("res://death.tscn")
@onready var winSCN = preload("res://win.tscn")

@onready var shop_Options = get_node("%Shop")
@onready var deathPRNTSCN = get_node("%deathParent")

#Text UI
@onready var scoreNeeded = $top_UI/scoreBox/ColorRect/scoreNeeded
@onready var scoreCurrent = $top_UI/scoreBox/ColorRect2/scoreCurrent
@onready var dollarUI = $top_UI/dollar_UI
@onready var lvlText = $levelText
#Trait Text
@onready var insomText = $bottom_UI/Spacer4/HBoxContainer/textContainer/insomLabel
@onready var lunarText = $bottom_UI/Spacer4/HBoxContainer/textContainer/lunarLabel
@onready var moistText = $bottom_UI/Spacer4/HBoxContainer/textContainer/moistLabel
@onready var gamerText = $bottom_UI/Spacer4/HBoxContainer/textContainer/gamerLabel
@onready var sharkText = $bottom_UI/Spacer4/HBoxContainer/textContainer/sharkLabel
@onready var catText = $bottom_UI/Spacer4/HBoxContainer/textContainer/catLabel
@onready var greenText = $bottom_UI/Spacer4/HBoxContainer/textContainer/greenLabel
@onready var viText = $bottom_UI/Spacer4/HBoxContainer/textContainer/viLabel


#timers
@onready var timerLB = $top_UI/Spacer2/timerLabel
@onready var timer = $top_UI/Spacer2/timer

#Sound Effects
@onready var pickUpSound = $pickUpSnd
@onready var buttonSound = $buttonSnd
@onready var meepSound = $meepSnd
@onready var levelSound = $levelSnd

var itemList = []
var ownedItems = []
var refresh = 0

var level = 1
var score = 0
var winCon = 0
var turn = 1
var base = 0
var multi = 1
var econ = 0

#Trait List
var itemTraits = 3 + (1) #Used for amount of traits. +1 as range function ends 1 too early
var traitList = {}
var insomn1akz = 0
var lunarSquad = 0
var moist = 0
var gamer = 0
var shark = 0
var cat = 0
var green = 0
var vi = 0


func _process(_delta):
	if Input.is_action_just_pressed("refresh_Button") && GlobalVar.getDollars() > 0:
		refresh_Shop()
	elif Input.is_action_just_pressed("refresh_Button") && GlobalVar.getDollars() <= 0:
		meepSound.play()
	timerLB.text = str(floor(timer.time_left))

func _ready():
	GlobalVar.dollars = 6
	refresh_Shop()
	getWinScore()
	
	dollarUI.text = "Dollars : $ " + str(GlobalVar.getDollars())
	lvlText.text = "Level: " + str(level) + " $ " + str(((level)**2) +2)

func _on_reroll_button_button_down():
	if GlobalVar.getDollars() > 0:
		refresh_Shop()
	else:
		meepSound.play()

func refresh_Shop():
	buttonSound.play()	
	for n in shop_Options.get_children():
		shop_Options.remove_child(n)
		n.queue_free()
	refresh += 1
	GlobalVar.subDollars(1)
	dollarUI.text = "Dollars : $ " + str(GlobalVar.getDollars())
	
	var options = 0
	var optionsmax = 5
	while options < optionsmax:
		var options_choice = itemSCN.instantiate()
		options_choice.item = get_random_Option(level)
		shop_Options.add_child(options_choice)
		options += 1

func shopPurchase(item):
	pickUpSound.play()
	
	base += Items.ITEMS[item]["score"]
	multi += Items.ITEMS[item]["multi"]
	score = base * multi
	GlobalVar.addDollars(Items.ITEMS[item]["gold"])
	
	var timeAdd = Items.ITEMS[item]["time"]
	timer.set_wait_time(timer.time_left+timeAdd)
	timer.start()
	
	dollarUI.text = "Dollars : $ " + str(GlobalVar.getDollars()) 
	scoreCurrent.text = "Current Score: " + str(score)
	
	if ownedItems.has(Items.ITEMS[item]["displayname"]) == false:
		ownedItems.append(Items.ITEMS[item]["displayname"])
		for x in range(1,itemTraits):
			var traitFixer = "trait" + (str)(x)
			traitMatcher(Items.ITEMS[item][traitFixer])
			updateTraits()
	checkWinCon()

func get_random_Option(playerLevel):
	for i in Items.ITEMS:
		if Items.ITEMS[i]["cost"] <= playerLevel:
			if itemList.has(i):
				pass
			else:
				itemList.append(i)
	return itemList.pick_random()

func _on_turn_button_button_down():
	if score >= winCon:
		checkWinCon()
		refresh_Shop()
		GlobalVar.addDollars(1)
		if timer.time_left <= 60:
			timer.set_wait_time(60)
			timer.start()
	else:
		death()
		
	econ = floor(GlobalVar.getDollars() / 10)
	GlobalVar.addDollars(econ)
	dollarUI.text = "Dollars : $ " + str(GlobalVar.getDollars()) 
	
	turn += 1
	getWinScore()


func _on_level_button_button_down():
	if level == 5:
		meepSound.play()
		pass
	elif GlobalVar.getDollars() <= ((level**2) +2):
		meepSound.play()
		pass
	elif GlobalVar.getDollars() >= ((level**2) + 2):
		levelSound.play()
		GlobalVar.subDollars((level**2) + 2)
		dollarUI.text = "Dollars : $ " + str(GlobalVar.getDollars()) 
		level += 1
	
	if level < 5:
		lvlText.text = "Level: " + str(level) + " $ " + str(((level)**2) +2)
	else:
		lvlText.text = "Level: 5"
		
func getWinScore():
	winCon = turn**3 + (14*turn**3)
	scoreNeeded.text = "Score Needed:" + str(winCon)

func checkWinCon():
	if insomn1akz == 11 && lunarSquad == 6 && moist == 8 && gamer == 6 && shark == 3 && cat == 4 && green == 4 && vi == 3:
		deathPRNTSCN.set_visible(true)
		timer.set_paused(true)
		deathPRNTSCN.add_child(winSCN.instantiate())

func death():
	meepSound.play()
	deathPRNTSCN.set_visible(true)
	timer.set_paused(true)
	deathPRNTSCN.add_child(deathSCN.instantiate())

func _on_timer_timeout():
	death()
	

func traitMatcher(traitName):
	match traitName:
		"1nsomn1akz":
			insomn1akz += 1
		"Lunar Squad": 
			lunarSquad += 1
		"Affiliated":
			moist += 1
		"Gamer":
			gamer += 1
		"Shark":
			shark += 1
		"Cat":
			cat += 1
		"Green":
			green += 1
		"VI":
			vi += 1
		null:
			pass

func updateTraits():
	insomText.text = str(insomn1akz) + "/11"
	lunarText.text = str(lunarSquad) + "/6"
	moistText.text = str(moist) + "/8"
	gamerText.text = str(gamer) + "/6"
	sharkText.text = str(shark) + "/3"
	catText.text = str(cat) + "/4" 
	greenText.text = str(green) + "/4"
	viText.text = str(vi) + "/3" 
