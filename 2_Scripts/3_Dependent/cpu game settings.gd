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

var mapGrid : Vector2i = Vector2i(10, 10)
var customMapPath : String = ""
var holePercent : float = 0.20
var strayTiles : bool = false

var playerDeck : Deck = load("res://5_Resources/0_Premade Decks/standard deck.tres")
var cpuDeck : Deck = load("res://5_Resources/0_Premade Decks/standard deck.tres")
