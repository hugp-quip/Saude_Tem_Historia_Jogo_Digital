extends Control

signal position_change()

func _set(property: StringName, value: Variant) -> bool:
		position_change.emit()
		return true
	