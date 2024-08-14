extends Area2D

# Define una señal personalizada llamada 'hit' que puede ser emitida por el jugador.
signal hit

# Exporta una variable que define la velocidad del jugador.
@export var speed = 400
# Variable para almacenar el tamaño de la pantalla.
var screen_size

# Función que se ejecuta cuando la escena está lista (cuando se carga).
func _ready():
	# Obtiene el tamaño de la pantalla desde el viewport.
	screen_size = get_viewport_rect().size
	# Imprime el tamaño de la pantalla en la consola (para depuración).
	print(screen_size)
	# Oculta el jugador al inicio.
	hide()

# Función que se ejecuta en cada frame. 'delta' es el tiempo transcurrido desde el último frame.
func _process(delta):
	
	# Inicializa la variable de velocidad como un vector nulo (sin movimiento).
	var velocity = Vector2.ZERO
	
	# Detecta si se están presionando las teclas de movimiento y ajusta la velocidad en consecuencia.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1  # Mueve a la derecha
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1  # Mueve a la izquierda
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1  # Mueve hacia abajo
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1  # Mueve hacia arriba
	
	# Si hay movimiento (la longitud del vector de velocidad es mayor a 0):
	if velocity.length() > 0:
		# Normaliza la velocidad y la multiplica por la velocidad del jugador.
		velocity = velocity.normalized() * speed
		# Reproduce la animación del jugador.
		$AnimatedSprite2D.play()
	else:
		# Detiene la animación si no hay movimiento.
		get_node("AnimatedSprite2D").stop()
		
	# Actualiza la posición del jugador según la velocidad y el tiempo transcurrido.
	position += velocity * delta
	# Asegura que el jugador permanezca dentro de los límites de la pantalla.
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Controla la animación dependiendo de la dirección del movimiento.
	if velocity.x != 0:
		$AnimatedSprite2D.play("walk")  # Reproduce la animación de caminar
		$AnimatedSprite2D.flip_h = velocity.x < 0  # Voltea la animación horizontalmente si se mueve a la izquierda
	elif velocity.y != 0:
		$AnimatedSprite2D.play("up")  # Reproduce la animación de moverse hacia arriba
		$AnimatedSprite2D.flip_v = velocity.y > 0  # Voltea la animación verticalmente si se mueve hacia abajo

# Función que se ejecuta cuando el jugador colisiona con otro cuerpo.
func _on_body_entered(body):
	# Oculta el jugador al colisionar.
	hide()
	# Emite la señal 'hit' para notificar que el jugador ha sido golpeado.
	hit.emit()
	# Desactiva la colisión del jugador para que no pueda colisionar nuevamente.
	$CollisionShape2D.set_deferred("disabled", true)
	
# Función que inicia el jugador en una posición específica.
func start(pos):
	# Coloca al jugador en la posición inicial proporcionada.
	position = pos
	# Muestra al jugador en la pantalla.
	show()
	# Reactiva la colisión del jugador.
	$CollisionShape2D.disabled = false
