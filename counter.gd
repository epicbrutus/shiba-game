extends RichTextLabel

var tempNum: int = 1

func set_count() -> void:
	tempNum += 1
	text = "Level:\n" + str(tempNum)