extends Node

var time_elapsed: float = 0

var times: Array[float] = [
    0,
    5,
    10,
    15,
    18,
    22,
    24,
    25,
    26
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

#1. This is Samuel
#2. He jumped down the CIA's top secret pit to screw with the government
#3. He can move with WASD/Arrows
#4. and must eat food to gain weight
#5. while avoiding obstacles and bad food to keep it
#6. so he can have enough force to break through the pits' barriers
#7. but be warned...
#8. more weight = more inertia too!
#9. and too little weight | by the time the bar runs out... 