extends Resource

class_name LocalGameSettings

var mapLayout : MapLayout = MapLayout.x10x10
enum MapLayout{
	x7x7,
	x10x10,
	x15x15,
	custom
}
func _get_map_layout() -> Vector2i:
	var newMapLayout : Vector2i = Vector2i.ZERO
	
	match mapLayout:
		MapLayout.x7x7:
			newMapLayout = Vector2i(7, 7)
		MapLayout.x10x10:
			newMapLayout = Vector2i(10, 10)
		MapLayout.x15x15:
			newMapLayout = Vector2i(15, 15)
		MapLayout.custom:
			newMapLayout = Vector2i(10, 10)
	
	return newMapLayout
var customMapPath : String = ""

var holePercent : HolePercent = HolePercent.x20
enum HolePercent{
	x5,
	x20,
	x35,
	none
}
func _get_hole_percent() -> float:
	var newHolePercent : float = -1
	
	match holePercent:
		HolePercent.x5:
			newHolePercent = 0.05
		HolePercent.x20:
			newHolePercent = 0.20
		HolePercent.x35:
			newHolePercent = 0.35
		HolePercent.none:
			newHolePercent = 0
	
	return newHolePercent

var strayTiles : bool = false

var blueDeck : Decks = Decks.standard
var redDeck : Decks = Decks.standard
enum Decks{
	standard,
	half,
	doubled,
	low,
	high,
	custom
}
func _get_deck(deckToGet : Decks) -> Deck:
	var newDeck : Deck = null
	
	match deckToGet:
		Decks.standard:
			newDeck = load("res://5_Resources/0_Premade Decks/standard deck.tres")
		Decks.half:
			newDeck = load("res://5_Resources/0_Premade Decks/half deck.tres")
		Decks.doubled:
			newDeck = load("res://5_Resources/0_Premade Decks/doubled deck.tres")
		Decks.low:
			newDeck = load("res://5_Resources/0_Premade Decks/low deck.tres")
		Decks.high:
			newDeck = load("res://5_Resources/0_Premade Decks/high deck.tres")
		Decks.custom:
			newDeck = load("res://5_Resources/0_Premade Decks/test deck.tres") #NOTE: only in itch.io verison
	
	return newDeck
