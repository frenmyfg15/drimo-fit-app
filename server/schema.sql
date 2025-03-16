CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    correo VARCHAR(255) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    objetivo ENUM('subir peso', 'bajar peso', 'definir', 'mantener peso', 'mejorar resistencia') NOT NULL,
    lugar ENUM('gimnasio', 'casa', 'aire libre') NOT NULL,
    actividad ENUM('sedentario', 'ligero', 'moderado', 'muy activo') NOT NULL,
    sexo ENUM('masculino', 'femenino') NOT NULL,
    enfoque ENUM('pecho', 'espalda', 'brazo', 'pierna', 'gluteo', 'todo') NOT NULL,
    dias JSON NOT NULL,
    peso DECIMAL(5, 2),
    unidad_peso ENUM('kilos', 'libras') NOT NULL,
    peso_objetivo DECIMAL(5, 2),
    altura DECIMAL(5, 2),
    unidad_altura ENUM('metros', 'pies') NOT NULL,
    edad INT NOT NULL,
    horas_entrenamiento VARCHAR(50),
    restricciones_fisicas JSON,
    rutina_id INT,
    confirmacion_correo BOOLEAN DEFAULT FALSE,
    token_confirmacion VARCHAR(255),
    suscripcion BOOLEAN DEFAULT FALSE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla rutinas (para la relación)
CREATE TABLE rutinas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    nivel ENUM('principiante', 'intermedio', 'avanzado') NOT NULL,
    objetivo ENUM('subir peso', 'bajar peso', 'definir', 'mantener peso', 'mejorar resistencia') NOT NULL,
    usuario_creador_id INT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_creador_id) REFERENCES usuarios(id)
);

-- Tabla dias (relacionada con rutinas)
CREATE TABLE dias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rutina_id INT NOT NULL,
    nombre_dia ENUM('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo') NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rutina_id) REFERENCES rutinas(id)
);

-- Tabla ejercicios_asignados (relacionada con dias y ejercicios)
CREATE TABLE ejercicios_asignados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dia_id INT NOT NULL,
    ejercicio_id INT NOT NULL,
    descanso INT NOT NULL, -- Tiempo de descanso en segundos
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dia_id) REFERENCES dias(id),
    FOREIGN KEY (ejercicio_id) REFERENCES ejercicios(id)
);

-- Tabla series (relacionada con ejercicios_asignados)
CREATE TABLE series (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ejercicio_asignado_id INT NOT NULL,
    repeticiones INT NOT NULL,
    tiempo_aproximado INT NOT NULL, -- Tiempo en segundos
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ejercicio_asignado_id) REFERENCES ejercicios_asignados(id)
);

-- Tabla peso_series (relacionada con series)
CREATE TABLE peso_series (
    id INT AUTO_INCREMENT PRIMARY KEY,
    serie_id INT NOT NULL,
    peso_levantado DECIMAL(5, 2) NOT NULL, -- Peso levantado por el usuario
    unidad_peso ENUM('kilos', 'libras') NOT NULL, -- Unidad del peso
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (serie_id) REFERENCES series(id)
);

-- Tabla ejercicios (independiente)
CREATE TABLE ejercicios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    lugar ENUM('gimnasio', 'casa', 'aire libre') NOT NULL,
    imagen VARCHAR(255), -- URL o ruta de la imagen
    video VARCHAR(255), -- URL o ruta del video
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo ENUM('fuerza', 'cardio', 'resistencia', 'movilidad'),
    musculo ENUM('pecho', 'pierna', 'biceps', 'abdomen', 'gluteo', 'espalda', 'core', 'triceps', 'hombro'),
    parte_musculo ENUM('pecho superior', 'pecho medio', 'pecho inferior', 'espalda alta', 'espalda media', 
    'espalda baja', 'hombro anterior', 'hombro lateral', 'hombro posterior', 'cabeza larga biceps', 'cabeza corta biceps', 
    'cabeza lateral triceps', 'cabeza medial triceps', 'cabeza larga triceps','cuadriceps', 'femoral', 'abductores', 'aductores', 'gemelos', 'gluteo mayor', 
    'gluteo medio', 'gluteo menor', 'recto abdominal', 'oblicuos', 'transverso', 'completo', 'ejercicio de resistencia')
    restricciones JSON,
    dificultad ENUM('principiante', 'intermedio', 'avanzado') DEFAULT 'intermedio',
    calorias_por_set DECIMAL(5, 2)
);

-- Tabla materiales (relacionada con ejercicios)
CREATE TABLE materiales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ejercicio_id INT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    cantidad INT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ejercicio_id) REFERENCES ejercicios(id)
);

-- Tabla instrucciones (relacionada con ejercicios)
CREATE TABLE instrucciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ejercicio_id INT NOT NULL,
    paso INT NOT NULL, -- Número de paso
    descripcion TEXT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ejercicio_id) REFERENCES ejercicios(id)
);

-- Tabla hashtags (relacionada con ejercicios)
CREATE TABLE hashtags (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ejercicio_id INT NOT NULL,
    tag VARCHAR(100) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ejercicio_id) REFERENCES ejercicios(id)
);

-- Tabla estadisticas
CREATE TABLE estadisticas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    ejercicio_id INT NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (ejercicio_id) REFERENCES ejercicios(id) ON DELETE CASCADE
);

-- Tabla fechas
CREATE TABLE fechas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    estadistica_id INT NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (estadistica_id) REFERENCES estadisticas(id) ON DELETE CASCADE
);

-- Tabla series_estadistica
CREATE TABLE series_estadistica (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha_id INT NOT NULL,
    peso DECIMAL(5, 2) NOT NULL,
    repeticiones INT NOT NULL,
    serie INT NOT NULL,
    FOREIGN KEY (fecha_id) REFERENCES fechas(id) ON DELETE CASCADE
);

-- Tabla registro de rutina completada
CREATE TABLE rutina_completada (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);