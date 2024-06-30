extends ColorRect

var item = null

@onready var main =get_tree().get_first_node_in_group("Main")

@onready var lbName = $Panel/lb_Name
@onready var lbDesc = $Panel/lb_Desc
@onready var itemIcon = $Panel/item_Icon
@onready var trait1 = $Panel/lb_TraitsOne
@onready var trait2 = $Panel/lb_TraitsTwo
@onready var trait3 = $Panel/lb_TraitsThree
@onready var lbCost = $Panel/purchaseButton/lb_Cost
@onready var greyItem = $greyOut
@onready var traitBox = $traitBox
@onready var traitBoxDesc = $traitBox/traitHover


signal itemSignal(item)

func _ready():
	connect("itemSignal", Callable(main,"shopPurchase"))
	if item == null:
		item = "VI_Gura"
	itemIcon.texture = load(Items.ITEMS[item]["icon"])
	lbName.text = Items.ITEMS[item]["displayname"]
	lbDesc.text = Items.ITEMS[item]["details"]
	if Items.ITEMS[item]["trait1"] != null:
		trait1.text = Items.ITEMS[item]["trait1"] 
	if Items.ITEMS[item]["trait2"] != null:
		trait2.text = Items.ITEMS[item]["trait2"] 
	if Items.ITEMS[item]["trait3"] != null:
		trait3.text = Items.ITEMS[item]["trait3"] 
	lbCost.text = "$" + str(Items.ITEMS[item]["cost"])



func _on_purchase_button_button_down():
	if GlobalVar.getDollars() >= Items.ITEMS[item]["cost"]:
		GlobalVar.subDollars(Items.ITEMS[item]["cost"])
		emit_signal("itemSignal",item)
		queue_free()
	
func _on_lb_traits_one_mouse_entered():
	if Items.ITEMS[item]["trait1"] != null:
		#traitBox.set_visible(true)
		traitBoxDesc.text = Items.TRAITS[Items.ITEMS[item]["trait1"]]["desc"]

func _on_lb_traits_two_mouse_entered():
	if Items.ITEMS[item]["trait2"] != null:
		#traitBox.set_visible(true)
		traitBoxDesc.text = Items.TRAITS[Items.ITEMS[item]["trait2"]]["desc"]

func _on_lb_traits_three_mouse_entered():
	if Items.ITEMS[item]["trait3"] != null:
		#traitBox.set_visible(true)
		traitBoxDesc.text = Items.TRAITS[Items.ITEMS[item]["trait3"]]["desc"]

func _on_lb_traits_one_mouse_exited():
	traitBox.set_visible(false)


func _on_lb_traits_two_mouse_exited():
	traitBox.set_visible(false)

func _on_lb_traits_three_mouse_exited():
	traitBox.set_visible(false)
