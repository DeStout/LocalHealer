@tool
extends EditorScenePostImport


var new_root: Node = null


func _post_import(root : Node):
	new_root = root.get_child(0)
	root.remove_child(new_root)
	_set_new_owner(new_root, true)
	return new_root


func _set_new_owner(next_node: Node, is_root: bool = false) -> void:
	next_node.owner = null if is_root else new_root
	for child: Node in next_node.get_children():
		_set_new_owner(child)
