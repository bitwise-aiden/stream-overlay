# Private variables

var __file: File = null
var __file_size: int = 0
var __location: int = 0


# Lifecycle methods

func _init(file: File) -> void:
	__file = file
	__file_size = __file.get_len()


# Public methods

func chunk() -> PoolByteArray:
	var size = min(__file_size - __location, 1048576)
	var buffer: PoolByteArray = __file.get_buffer(size)

	__location += size

	if __location >= __file_size:
		__file.close()

	return buffer


func end_of_file() -> bool:
	return !__file.is_open()
