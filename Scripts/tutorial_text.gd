extends Node

var time_elapsed: float = 0

var times: Array[float] = [
    0,
    3.7,
    7.7,
    10,
    12,
    16,
    18.5
]

@onready var texts: Array = get_children()

func _physics_process(delta: float):
    time_elapsed += delta
    #print(time_elapsed)
    for i in range(0, times.size()):
        if time_elapsed > times[i] && (i == times.size() - 1 || time_elapsed < times[i + 1]):
            print(texts.size())
            for i2 in range(0, texts.size()):
                if i2 == i:
                    texts[i2].visible = true
                    print("VISIBLE")
                else:
                    texts[i2].visible = false