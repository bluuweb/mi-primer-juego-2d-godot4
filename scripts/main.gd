extends Node

# Exporta una variable de tipo PackedScene, que es una escena precargada.
# Esta será la plantilla para instanciar nuevos mobs (enemigos o obstáculos).
@export var mob_scene: PackedScene

# Declara una variable para almacenar el puntaje.
var score

# Función que se ejecuta cuando la escena está lista (cuando se carga).
func _ready():
	# Llama a la función que inicia un nuevo juego.
	# new_game()
	pass

# Función que detiene el juego, desactivando los temporizadores.
func game_over():
	# Detiene el temporizador del puntaje.
	$ScoreTimer.stop()
	# Detiene el temporizador que genera mobs.
	$MobTimer.stop()
	
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

# Función que inicia un nuevo juego.
func new_game():
	# Reinicia el puntaje a 0.
	score = 0
	# Coloca al jugador en la posición inicial.
	$Player.start($StartPosition.position)
	# Inicia el temporizador que da comienzo al juego.
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

# Función que se ejecuta cuando el temporizador de mobs alcanza el tiempo límite.
func _on_mob_timer_timeout():
	# Instancia un nuevo mob usando la escena precargada.
	var mob = mob_scene.instantiate()
	# Obtiene la ubicación de spawn de mobs en el camino (MobPath).
	var mob_spawn_location = $MobPath/MobSpawnLocation
	# Asigna una posición aleatoria en el camino donde el mob aparecerá.
	mob_spawn_location.progress_ratio = randf()
	
	# Calcula la dirección inicial del mob con una rotación aleatoria.
	var direction = mob_spawn_location.rotation + PI / 2
	# Coloca al mob en la posición calculada en el camino.
	mob.position = mob_spawn_location.position
	
	# Añade un pequeño rango de aleatoriedad a la dirección del mob.
	direction += randf_range(-PI / 4, PI / 4)
	# Asigna la dirección calculada al mob.
	mob.rotation = direction
	
	# Establece la velocidad del mob, también con algo de aleatoriedad.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	# Aplica la rotación a la velocidad para que el mob se mueva en la dirección correcta.
	mob.linear_velocity = velocity.rotated(direction)

	# Añade el mob como hijo del nodo principal de la escena.
	add_child(mob)

# Función que se ejecuta cuando el temporizador de puntaje alcanza el tiempo límite.
func _on_score_timer_timeout():
	# Incrementa el puntaje en 1.
	score += 1
	$HUD.update_score(score)

# Función que se ejecuta cuando el temporizador de inicio alcanza el tiempo límite.
func _on_start_timer_timeout():
	# Imprime "start" en la consola (para depuración).
	print("start")
	# Inicia el temporizador que genera mobs.
	$MobTimer.start()
	# Inicia el temporizador que cuenta el puntaje.
	$ScoreTimer.start()
