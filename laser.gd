extends Weapon
class_name laser

func shoot(source, target, scene_tree):
	if source == null:
		return
	
	# Define the horizontal laser length
	var laser_length = 200  # Adjust the length as needed
	
	# Calculate the laser's end point
	var laser_end_position = source.position + Vector2(laser_length, 0)
	
	# Create a laser effect (e.g., a line or beam)
	var laser = Line2D.new()
	laser.default_color = Color(1, 0, 0)  # Red color for the laser
	laser.width = 5  # Adjust the width of the laser
	
	# Set the laser's start and end points
	laser.points = [source.position, laser_end_position]
	
	# Add the laser to the scene
	scene_tree.current_scene.add_child(laser)
	
	# Optional: Inflict damage to any objects in the laser's path
	# Example: Check collisions here if needed

	# Wait for 0.1 seconds before removing the laser
	await scene_tree.create_timer(0.1).timeout
	laser.queue_free()

func activate(source, target, scene_tree):
	shoot(source, target, scene_tree)
