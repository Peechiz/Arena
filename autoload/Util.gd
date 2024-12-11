extends Node

func flat(acc, item) -> Array:
	if typeof(item) == TYPE_ARRAY:
		for sub_item in item:
			acc = flat(acc, sub_item)
	else:
		acc.append(item)
	return acc

func yell(text: String) -> void:
	print("\n#####################")
	print(text)
	print("#####################\n")
