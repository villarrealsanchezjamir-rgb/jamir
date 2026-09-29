-- Consultas operativas recomendadas (documento 04, sección 22)
-- Base de datos: gestion_vehiculos (ver schema.sql)

-- Vehículos disponibles
SELECT * FROM vehiculo WHERE estado = 'Disponible';

-- Documentos próximos a vencer (30 días)
SELECT *
FROM documento_vehiculo
WHERE fecha_vencimiento BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY);

-- Mantenimientos por vehículo
SELECT * FROM mantenimiento WHERE id_vehiculo = ? ORDER BY fecha DESC;

-- Alquileres activos
SELECT * FROM alquiler WHERE estado = 'Activo';

-- Historial de una unidad
SELECT * FROM historial_vehiculo WHERE id_vehiculo = ? ORDER BY fecha DESC;
