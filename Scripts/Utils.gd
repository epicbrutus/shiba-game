extends Node
class_name Utils


static func get_random_photo_from_folder(folder_path: String) -> String:
	print(folder_path)
	var dir = DirAccess.open(folder_path)
	if dir == null:
		return ""
	
	var files = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".png"):
			files.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	if files.size() == 0:
		return ""
	
	var random_file = files[randi() % files.size()]
	print(folder_path + "/" + random_file)
	return folder_path + "/" + random_file

static func get_spawner() -> Node2D:
	return Engine.get_main_loop().get_first_node_in_group("spawner")
