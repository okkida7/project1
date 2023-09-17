extends AudioStreamPlayer2D

# Declare the audio file as an export variable so it can be set from the editor
@export var audio_stream : AudioStream

func _ready():
	# Set the audio stream of the AudioStreamPlayer
	self.stream = audio_stream

	# Play the music if it isn't playing
	if not is_playing():
		play()

	# Ensure the music doesn't stop if the scene changes
	set_process(false)

# This function ensures the music doesn't play more than once across scenes
func play_music():
	if not is_playing():
		play()
