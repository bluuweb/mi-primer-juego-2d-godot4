extends RigidBody2D

# Función que se ejecuta cuando la escena está lista (cuando se carga).
func _ready():
	# Obtiene los nombres de todas las animaciones en el sprite del mob.
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	# Selecciona una animación aleatoria para reproducir al inicio.
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

# Función que se ejecuta cuando el mob sale de la pantalla.
func _on_visible_on_screen_notifier_2d_screen_exited():
	# Cuando el mob ya no es visible en la pantalla, se elimina de la escena.
	queue_free()
