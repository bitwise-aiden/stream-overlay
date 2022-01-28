class_name DataApplication extends Data


# Public variables

var profile: String = "default"


# Public methods

func copy(other: Data) -> void:
	other.profile = profile
