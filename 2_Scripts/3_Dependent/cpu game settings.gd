extends Resource

class_name CPUGameSettings

var difficulty : Difficulty = Difficulty.easy
enum Difficulty{
	easy,
	medium,
	hard
}

var cpuColor : CPUColor = CPUColor.red
enum CPUColor{
	blue,
	red,
	random
}

var mapLayout : MapLayout = MapLayout.x7x7
enum MapLayout{
	x7x7,
	x10x10,
	x15x15,
	custom
}
var customMapPath : String = ""

var holePercent : HolePercent = HolePercent.x20
enum HolePercent{
	x5,
	x20,
	x35,
	none
}

var strayTiles : bool = false

var playerDeck : Deck = load("res://5_Resources/0_Premade Decks/standard deck.tres")
var cpuDeck : Deck = load("res://5_Resources/0_Premade Decks/standard deck.tres")
