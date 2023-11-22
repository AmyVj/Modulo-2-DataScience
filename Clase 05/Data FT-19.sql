USE HENRY;


-- 2) No se sabe con certeza el lanzamiento de las cohortes N° 1245 y N° 1246, se solicita que las elimine de la tabla.

SELECT * FROM cohorte;

DELETE FROM cohorte
WHERE IdCohorte IN 	(1245, 1246);		-- = 1245 OR IdCohorte = 1246;

-- 3) Se ha decidido retrasar el comienzo de la cohorte N°1243,
-- por lo que la nueva fecha de inicio será el 16/05. Se le solicita modificar la fecha de inicio de esos alumnos.

-- DATE -> YY-MM-DD -> 2022-05-16

SELECT * FROM alumno
WHERE IdCohorte = 1243;

UPDATE alumno
SET Fecha_Inicio = '2022-07-16'
WHERE IdCohorte = 1243;

SELECT * FROM cohorte;

UPDATE cohorte
SET Fecha_Inicio = '2022-05-16'
WHERE IdCohorte = 1243;
-- ESTE JOIN ME PERMITE MODIFICAR LOS DATOS DE LOS ALUMNOS RELACIONANDO A LA TABLA COHORTE

UPDATE alumno AS a INNER JOIN cohorte AS c
					ON (c.IdCohorte = a.IdCohorte)
SET a.Fecha_Inicio = c.Fecha_Inicio
WHERE a.IdCohorte = 1243;

-- pd.merge(how='INNER')

-- 4) El alumno N° 165 solicito el cambio de su Apellido por “Ramirez”.

SELECT * FROM alumno
WHERE IdAlumno = 165;

UPDATE alumno
SET Apellido = 'Ramirez'
WHERE IdAlumno = 165;

-- 5) El área de Learning le solicita un listado de alumnos de la Cohorte N°1243 que incluya la fecha de ingreso.

SELECT * FROM alumno;

SELECT IdAlumno, Nombre, Apellido, Fecha_Inicio, IdCohorte
FROM alumno
WHERE IdCohorte = 1243;

SELECT * FROM cohorte;

/*
TABLA A JOIN TABLA B 
		ON (A.Campo = B.Campo)  CAMPOS QUE TENGAN EN COMUN AMBAS TABLAS
 
 SELECT * FROM Df_Emisiones d JOIN Df_Paises p 
		ON (d.Clave_Hash = p.Clave_Hash)

df['Clave_Hash']    df.Calve_Hash
*/

SELECT a.IdAlumno, a.Nombre, a.Apellido, a.Fecha_Inicio, c.Codigo
FROM alumno a JOIN cohorte c
				ON (a.IdCohorte = c.IdCohorte)
WHERE a.IdCohorte = 1243;


-- 6) Como parte de un programa de actualización, el área de People le solicita un listado de los instructores que dictan la carrera de Full Stack Developer.

SELECT * FROM instructor;


SELECT IdInstructor
FROM cohorte
WHERE IdCarrera = 1
;
-- ACCEDEMOS PRIMERO A LA LISTA DE IdInstructor QUE DICTA IdCarrera 1
SELECT *
FROM instructor
WHERE IdInstructor IN (1,2,1,2,3,4,5,1,1); -- [IdInstructor for IdInstructor in instructor]

-- SUBCONSULTA O SUBQUERY
SELECT *
FROM instructor
WHERE IdInstructor IN (SELECT IdInstructor
						FROM cohorte
						WHERE IdCarrera = 1); -- [IdInstructor for IdInstructor in instructor]

-- APLICAMOS JOIN ENTRE INSTRUCTOR Y COHORTE
SELECT DISTINCT i.*, c.IdCarrera
FROM instructor i JOIN cohorte c
					ON (i.IdInstructor = c.IdInstructor)
WHERE c.IdCarrera = 1;


-- 7) Se desea saber que alumnos formaron parte de la cohorte N° 1235. Elabore un listado.

SELECT IdAlumno, CONCAT(Nombre, ' ', Apellido) AS 'Nombre Completo', IdCohorte 
FROM alumno
WHERE IdCohorte = 1235;

-- 8) Del listado anterior se desea saber quienes ingresaron en el año 2019


-- Utilizando la funcion YEAR(DATE) me devuelve el valor del año de ese DATE
SELECT IdAlumno, CONCAT(Nombre, ' ', Apellido) AS 'Nombre Completo', IdCohorte, Fecha_Inicio
FROM alumno
WHERE IdCohorte = 1235
AND YEAR(Fecha_Inicio) = 2019
;

-- Comparando con un LIKE, yo se que arranca en 2019- despues no se que hay en el patron, osea utilizo % '2019-%'
SELECT IdAlumno, CONCAT(Nombre, ' ', Apellido) AS 'Nombre Completo', IdCohorte, Fecha_Inicio
FROM alumno
WHERE IdCohorte = 1235
AND Fecha_Inicio LIKE '2019-%'
;

-- Utilizando un BETWEEN que compara entre un min y max y devuelve todo lo que este comprendido entre esos dos valores
SELECT IdAlumno, CONCAT(Nombre, ' ', Apellido) AS 'Nombre Completo', IdCohorte, Fecha_Inicio
FROM alumno
WHERE IdCohorte = 1235
AND Fecha_Inicio BETWEEN '2019-01-01' AND '2020-01-01'
;

/* 9)
SELECT alumno.Nombre, Apellido, Fecha_Nacimiento, cohorte.IdCarrera, carrera.IdCarrera, Carrera
FROM alumno
INNER JOIN cohorte
ON (alumno.Idcohorte=cohorte.IdCohorte)
INNER JOIN carrera
ON (cohorte.Idcarrera = carrera.IdCarrera);

*/

SELECT alumno.Nombre, Apellido, Fecha_Nacimiento, cohorte.IdCarrera, Carrera
FROM alumno
INNER JOIN cohorte
ON (alumno.Idcohorte=cohorte.IdCohorte)
INNER JOIN carrera
ON (cohorte.Idcarrera = carrera.IdCarrera);

-- a) Vamos a relacionar la tabla de alumnos con la tabla cohorte a traves de su IdCohorte, en la tabla Cohorte tenemos presente el IdCarrera
--   el cual vamos a utilizar para acceder desde cohorte hacia la tabla carrera

SELECT * FROM alumno;

-- b) Cohortes hay muchos alumnos, pero cada alumno pertenece a solo una cohorte -> 1:M

-- c) 


SELECT alumno.Nombre, Apellido, Fecha_Nacimiento, cohorte.IdCarrera, Carrera
FROM alumno
INNER JOIN cohorte
ON (alumno.Idcohorte=cohorte.IdCohorte)
INNER JOIN carrera
ON (cohorte.Idcarrera = carrera.IdCarrera)
WHERE Carrera LIKE 'F%'
; -- ESTA QUERY TE TRAE LOS ALUMNOS PERTENECIENTES A FULL STACK DEVELOPER CON LIKE

SELECT alumno.Nombre, Apellido, Fecha_Nacimiento, cohorte.IdCarrera, Carrera
FROM alumno
INNER JOIN cohorte
ON (alumno.Idcohorte=cohorte.IdCohorte)
INNER JOIN carrera
ON (cohorte.Idcarrera = carrera.IdCarrera)
WHERE Carrera NOT LIKE 'Data S%'
;-- ESTE QUERY ME TRAE TODOS LOS ALUMNOS QUE NO PERTENEZCAN A DATA

-- La forma mas logica es con el LIKE, asi me aseguro que traigo solamente lo que quiero

-- d) 

SELECT alumno.Nombre, Apellido, Fecha_Nacimiento, cohorte.IdCarrera, Carrera
FROM alumno
INNER JOIN cohorte
ON (alumno.Idcohorte=cohorte.IdCohorte)
INNER JOIN carrera
ON (cohorte.Idcarrera = carrera.IdCarrera)
WHERE Carrera = 'Full Stack Developer'
; -- ESTE QUERY ME TRAE LOS ALUMNOS QUE PERTENECEN A Full Stack Developer

SELECT alumno.Nombre, Apellido, Fecha_Nacimiento, cohorte.IdCarrera, Carrera
FROM alumno
INNER JOIN cohorte
ON (alumno.Idcohorte=cohorte.IdCohorte)
INNER JOIN carrera
ON (cohorte.Idcarrera = carrera.IdCarrera)
WHERE Carrera <> 'Data Science'
; -- ESTE QUERY ME TRAE LOS ALUMNOS QUE NO PERTENECEN A DATA SCIENCE

-- La forma logica de buscar los que pertenecen a Full Stack Developer es con = 


-- e) Lo empleamos con IdCarrera = 1

SELECT alumno.Nombre, Apellido, Fecha_Nacimiento, cohorte.IdCarrera, Carrera
FROM alumno
INNER JOIN cohorte
ON (alumno.Idcohorte=cohorte.IdCohorte)
INNER JOIN carrera
ON (cohorte.Idcarrera = carrera.IdCarrera)
WHERE cohorte.IdCarrera = 1
;

-- LECTURE

-- ORDER BY

SELECT IdAlumno, CONCAT(Nombre, ' ', Apellido) AS 'Nombre Completo', IdCohorte 
FROM alumno
WHERE IdCohorte = 1235
ORDER BY CONCAT(Nombre, ' ', Apellido) DESC;
  
 -- ASC -> ASCENDENTE  MENOR A MAYOR
 -- DESC -> DESCENDENTE MAYOR A MENOR
 
 -- LIMIT
 
 SELECT IdAlumno, CONCAT(Nombre, ' ', Apellido) AS 'Nombre Completo', IdCohorte 
FROM alumno
WHERE IdCohorte = 1235
ORDER BY CONCAT(Nombre, ' ', Apellido) DESC
LIMIT 1;  -- SOLO ME DEVUELVE EL PRIMER REGISTRO

SELECT IdAlumno, CONCAT(Nombre, ' ', Apellido) AS 'Nombre Completo', IdCohorte 
FROM alumno
WHERE IdCohorte = 1235
ORDER BY CONCAT(Nombre, ' ', Apellido) DESC
LIMIT 5   -- SOLO ME DEVUELVE LOS PRIMEROS 5 REGISTROS
;

SELECT IdAlumno, CONCAT(Nombre, ' ', Apellido) AS 'Nombre Completo', IdCohorte 
FROM alumno
WHERE IdCohorte = 1235
ORDER BY CONCAT(Nombre, ' ', Apellido) DESC
LIMIT 5, 10
;


-- COUNT

SELECT COUNT(*)
FROM alumno;
-- COUNT()  CUENTA LOS REGISTROS

SELECT COUNT(IdAlumno)
FROM alumno
WHERE IdCohorte = 1235;
-- Cuantos alumnos hay en la cohorte 1235

-- SUM() SUMA LOS REGISTROS NUMERICOS

SELECT SUM(Cantidad)
FROM producto;
-- Cuantos productos me quedan en stock?

SELECT SUM(IdCohorte)
FROM alumno;


SELECT SUM(Precio) / COUNT(Precio)
FROM producto;

SELECT SUM(IdCohorte) / COUNT(IdCohorte)
FROM alumno; -- 1239

-- AVG() AVERAGE  ME SIRVE PARA CALCULAR EL PROMEDIO

SELECT AVG(IdCohorte)
FROM alumno; -- 1239

SELECT AVG(Precio)
FROM producto;


-- MAX - MIN  

-- Obtenemos el ultimo alumno que ingreso

SELECT MAX(Fecha_Inicio)
FROM alumno;

-- Obtenemos el primer alumno que ingreso

SELECT MIN(Fecha_Inicio)
FROM alumno;

-- Obtenemos el alumno mas pequeño

SELECT MAX(Fecha_Nacimiento)
FROM alumno;

-- Obtenemos el alumno mas grande en edad
SELECT MIN(Fecha_Nacimiento)
FROM alumno; -- Conde Dracula


-- GROUP BY  Sirve para agrupar las salidas por cierta columna o campo
-- Error Code: 1140. In aggregated query without GROUP BY, expression #2 of SELECT list contains nonaggregated column 'henry.alumno.IdCohorte'; this is incompatible with sql_mode=only_full_group_by

SELECT COUNT(IdAlumno), IdCohorte
FROM alumno
GROUP BY IdCohorte;

SELECT COUNT(IdAlumno), Fecha_Nacimiento
FROM alumno
GROUP BY Fecha_Nacimiento
ORDER BY COUNT(IdAlumno) DESC;

SELECT COUNT(IdAlumno) AS Cantidad, Fecha_Nacimiento
FROM alumno
GROUP BY Fecha_Nacimiento
ORDER BY COUNT(IdAlumno) DESC
LIMIT 1;

-- HAVING   EL FILTRADO QUE SE LE APLICA AL GROUP BY

SELECT COUNT(IdAlumno) AS Cantidad, Fecha_Nacimiento
FROM alumno
GROUP BY Fecha_Nacimiento
HAVING COUNT(IdAlumno) > 1			-- Se le aplica filtrado al group by
ORDER BY COUNT(IdAlumno) DESC
;

SELECT COUNT(IdAlumno), Fecha_Nacimiento
FROM alumno
WHERE YEAR(Fecha_Nacimiento) > 2000
GROUP BY Fecha_Nacimiento
HAVING COUNT(IdAlumno) > 1
ORDER BY COUNT(IdAlumno) DESC;


/* ORDEN DE SENTENCIAS

SELECT indicamos los campos que queremos obtener
FROM de que tabla/s obtenemos los campos
OPCIONALES:
WHERE filtrado o condiciones de consulta
GROUP BY agrupamiento
HAVING de haber having sigue pegado al group by
ORDER BY ordenamiento
LIMIT 

*/

SELECT COUNT(IdAlumno), Fecha_Nacimiento
FROM alumno -- ACA IRIA LOS JOINS
WHERE YEAR(Fecha_Nacimiento) > 2000
GROUP BY Fecha_Nacimiento
HAVING COUNT(IdAlumno) > 1
ORDER BY COUNT(IdAlumno) DESC
LIMIT 1;