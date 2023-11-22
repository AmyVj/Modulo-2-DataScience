-- Code Review HW 7 M2

USE henry;


-- 1) ¿Cuantas carreas tiene Henry?

SELECT * FROM carrera;

SELECT COUNT(IdCarrera) -- Porque los ID son valores unicos
FROM carrera;

SELECT COUNT(*)
FROM carrera; -- Cuenta la cantidad de filas existentes en mi tabla

-- 2) ¿Cuantos alumnos hay en total?

SELECT * FROM alumno;

SELECT COUNT(IdAlumno)
FROM alumno; -- En total hay 180 alumnos

-- 3) ¿Cuantos alumnos tiene cada cohorte?

SELECT * FROM alumno;
--     [CAMPO1         ,    CAMPO2,         CAMPOn]
SELECT COUNT(IdAlumno), IdCohorte
FROM alumno
GROUP BY 2 -- IdCohorte
ORDER BY 1 ASC	-- COUNT(IdAlumno)
;
-- Error Code: 1140. In aggregated query without GROUP BY, expression #2 of SELECT list contains nonaggregated column 'henry.alumno.IdCohorte'; this is incompatible with sql_mode=only_full_group_by
SELECT COUNT(IdAlumno), IdCohorte
FROM alumno
WHERE IdCohorte > 1235
GROUP BY 2 -- IdCohorte
HAVING COUNT(IdAlumno) = 20
ORDER BY 1 ASC	-- COUNT(IdAlumno)
;


-- 4) Confecciona un listado de los alumnos ordenado por los últimos alumnos que ingresaron, con nombre y apellido en un solo campo.

SELECT IdAlumno,Nombre, Apellido, Fecha_Inicio
FROM alumno
ORDER BY Fecha_Inicio DESC;   -- DESC Es de mayor a menor

-- CONCAT(Nombre, Apellido) -> NombreApellido ;  CONCAT(Nombre, ' ',Apellido) -> Nombre Apellido

SELECT IdAlumno, CONCAT(Nombre, ' ',Apellido) AS 'Nombre Completo', Fecha_Inicio
FROM alumno
ORDER BY 3 DESC;   -- Campo #3 es Fecha_Inicio

-- 5) ¿Cual es el nombre del primer alumno que ingreso a Henry?

SELECT IdAlumno, CONCAT(Nombre, ' ', Apellido) AS 'Nombre Completo'
FROM alumno
ORDER BY Fecha_Inicio ASC
LIMIT 1;

-- 6) ¿En que fecha ingreso?
 
 SELECT MIN(Fecha_Inicio)
 FROM alumno;
 

-- Existe mas de un alumno que haya ingreso en esa fecha?

SELECT IdAlumno, CONCAT(Nombre, ' ', Apellido) AS 'Nombre Completo'
FROM alumno
WHERE Fecha_Inicio = '2019-12-04';

SELECT IdAlumno, CONCAT(Nombre, ' ', Apellido) AS 'Nombre Completo'
FROM alumno
WHERE Fecha_Inicio = (SELECT MIN(Fecha_Inicio) FROM alumno);  -- SUBCONSULTA


-- 7) ¿Cual es el nombre del ultimo alumno que ingreso a Henry?

SELECT IdAlumno, CONCAT(Nombre, ' ', Apellido) AS 'Nombre Completo'
FROM alumno
ORDER BY Fecha_Inicio DESC
LIMIT 1;


SELECT MAX(Fecha_Inicio) FROM alumno;

SELECT IdAlumno, CONCAT(Nombre, ' ', Apellido) AS 'Nombre Completo'
FROM alumno
WHERE Fecha_Inicio = '2022-05-16';


-- 8) La función YEAR le permite extraer el año de un campo date, utilice esta función y especifique cuantos alumnos ingresarona a Henry por año.

SELECT YEAR(CURDATE()); -- La funcion YEAR extrae el año
SELECT MONTH(CURDATE()); -- Extrae el mes
SELECT DAY(CURDATE()); -- Extrae el dia
SELECT SECOND(NOW()); -- Extrae los segundos
SELECT MINUTE(NOW()); -- Extrae los minutos
SELECT HOUR(NOW()); -- Extrae la hora

SELECT YEAR(Fecha_Inicio)
FROM alumno;

SELECT COUNT(IdAlumno), YEAR(Fecha_Inicio)
FROM alumno
GROUP BY YEAR(Fecha_Inicio) -- 2
ORDER BY 1 DESC -- COUNT(IdAlumno) DESC
;

-- 9) ¿Cuantos alumnos ingresaron por semana a henry?, indique también el año. WEEKOFYEAR()

SELECT WEEKOFYEAR(CURDATE()); -- La semana del año 

SELECT COUNT(IdAlumno) 'Cantidad', WEEKOFYEAR(Fecha_Inicio) 'Semana', YEAR(Fecha_Inicio) 'Año'
FROM alumno
GROUP BY 2 , 3   -- YO AGRUPO POR DOS CAMPOS, SEMANA Y AÑO 
ORDER BY 1 DESC
;


SELECT COUNT(IdAlumno), WEEKOFYEAR(Fecha_Inicio)
FROM alumno
GROUP BY 2   -- YO AGRUPO POR DOS CAMPOS, SEMANA Y AÑO 
ORDER BY 1 DESC
;

SELECT fecha_inicio
FROM alumno
WHERE YEAR(Fecha_Inicio) = 2019;


-- 10) ¿En que años ingresaron más de 20 alumnos?

SELECT COUNT(IdAlumno) 'Cantidad', YEAR(Fecha_Inicio) 'Año'
FROM alumno
GROUP BY YEAR(Fecha_Inicio)
HAVING COUNT(IdAlumno) > 20
ORDER BY 1 DESC
;


-- 11) TIMESTAMPDIFF() CURDATE()

SELECT CURDATE();
-- TIMESTAMPDIFF() ES TOMAR DOS VALORES DE TIPO TIEMPO Y HACE LA RESTA 

SELECT * FROM instructor; -- 1981-07-09    42 años

SELECT CONCAT(Nombre, ' ', Apellido) 'Nombre Completo', TIMESTAMPDIFF(YEAR, Fecha_Nacimiento, CURDATE()) 'Edad'
FROM instructor
ORDER BY 2 DESC; -- TIMESTAMPDIFF(YEAR, Fecha_Nacimiento, CURDATE())

SELECT CONCAT(Nombre, ' ', Apellido) 'Nombre Completo', TIMESTAMPDIFF(YEAR, Fecha_Nacimiento, CURDATE()) 'Edad',
		DATE_ADD(Fecha_Nacimiento, INTERVAL (TIMESTAMPDIFF(YEAR,Fecha_Nacimiento, CURDATE())) YEAR) 'Verificacion'
FROM instructor
ORDER BY 2 DESC;

UPDATE instructor
SET Fecha_Nacimiento = '1981-11-17'
WHERE Nombre = 'Antonio' AND Apellido = 'Barrios';


/*
12) Cálcula:
- La edad de cada alumno.
- La edad promedio de los alumnos de henry.
- La edad promedio de los alumnos de cada cohorte.
*/

-- La edad de cada alumno.
SELECT CONCAT(Nombre, ' ', Apellido) 'Nombre Completo', TIMESTAMPDIFF(YEAR, Fecha_Nacimiento, CURDATE()) 'Edad'
FROM alumno
ORDER BY 2 DESC;

-- La edad promedio de los alumnos de henry.
SELECT COUNT(IdAlumno) 'Cantidad', SUM(TIMESTAMPDIFF(YEAR, Fecha_Nacimiento, CURDATE())) 'Suma', SUM(TIMESTAMPDIFF(YEAR, Fecha_Nacimiento, CURDATE())) / COUNT(IdAlumno)
FROM alumno;

SELECT AVG(TIMESTAMPDIFF(YEAR, Fecha_Nacimiento, CURDATE())) ' Promedio De Edad'
FROM alumno;

--  La edad promedio de los alumnos de cada cohorte.
SELECT AVG(TIMESTAMPDIFF(YEAR, Fecha_Nacimiento, CURDATE())) 'Promedio de Edad', IdCohorte
FROM alumno
GROUP BY IdCohorte
;

-- 13) Elabora un listado de los alumnos que superan la edad promedio de Henry.

SELECT CONCAT(Nombre, ' ', Apellido) 'Nombre Completo', TIMESTAMPDIFF(YEAR, Fecha_Nacimiento, CURDATE()) 'Edad'
FROM alumno
WHERE TIMESTAMPDIFF(YEAR, Fecha_Nacimiento, CURDATE()) > 33
ORDER BY 1 ASC
;

-- con subconsulta
SELECT CONCAT(Nombre, ' ', Apellido) 'Nombre Completo', TIMESTAMPDIFF(YEAR, Fecha_Nacimiento, CURDATE()) 'Edad'
FROM alumno
WHERE TIMESTAMPDIFF(YEAR, Fecha_Nacimiento, CURDATE()) > (SELECT AVG(TIMESTAMPDIFF(YEAR, Fecha_Nacimiento, CURDATE())) FROM alumno)
ORDER BY 2 ASC
; -- NO MAREARSE EN EL M3 VAMOS A PROFUNDIZAR ESTO

-- LECTURE

USE henry_2;

SELECT * FROM persona;

SELECT * FROM alumnos; 

