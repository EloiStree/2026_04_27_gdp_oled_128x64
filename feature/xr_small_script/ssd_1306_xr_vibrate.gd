extends Node


@onready var right_hand: XRController3D = $RightHand
func is_drawing(is_drawing:bool):
	if is_drawing:
		if right_hand:
			right_hand.trigger_haptic_pulse(
				"haptic", # action name from XR Action Map
				0.0,      # frequency (0 = runtime default)
				1.0,      # amplitude 0..1
				0.1,      # duration seconds
				0.0       # delay seconds
			)
		else :
			right_hand.trigger_haptic_pulse(
				"haptic", # action name from XR Action Map
				0.0,      # frequency (0 = runtime default)
				0.0,      # amplitude 0..1
				0.0,      # duration seconds
				0.0       # delay seconds
			)
