class_name Data


# Public methods

func copy() -> Data:
	var data = json()
	return from_json(data)


func json() -> Dictionary:
	var values: Dictionary = {
		"_class": get_script().resource_path,
	}

	for property in get_property_list():
		var name: String = property["name"]
		if name in ["Reference", "Script Variables", "script"]:
			continue

		var value = get(name)

		if value is Array:
			var array_values: Array = []

			for item in value:
				if is_self(item):
					array_values.append(item.json())
				else:
					array_values.append(item)

			values[name] = array_values
		elif is_self(value):
			values[name] = value.json()
		else:
			values[name] = value

	return values


static func from_json(data: Dictionary) -> Data:
	var data_class: String = data.get("_class")
	if !data_class:
		return null

	# TODO: Validate class exists
	var script: Script = load(data_class)

	var data_object: Reference = Reference.new()
	data_object.set_script(script)

	for key in data:
		if key == "_class":
			continue

		var value = data[key]

		if value is Array:
			var array_values: Array = []

			for item in value:
				if item is Dictionary:
					var reference = from_json(item)
					if !reference:
						return null

					array_values.append(reference)
				else:
					array_values.append(item)

			data_object.set(key, array_values)
		elif value is Dictionary:
			data_object.set(key, from_json(value))
		else:
			data_object.set(key, value)

	return data_object as Data


# Private methods

func is_self(data: Data) -> bool:
	return data != null
