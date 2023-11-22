USE henry;

SELECT * FROM oferta_gastronomica;

DROP TABLE oferta_gastronomica;

CREATE TABLE oferta_gastronomica (
    id_local INT NOT NULL,
    Nombre VARCHAR(100),
    Categoria VARCHAR(100),
    Direccion VARCHAR(180),
    Comuna VARCHAR(50)
);

-- Como cambiar el nombre de una columna
-- ALTER TABLE nombre_tabla CHANGE columnaVieja columnaNueva TIPO DATO ;

ALTER TABLE oferta_gastronomica CHANGE id_local IdLocal INT NOT NULL;

SELECT * FROM oferta_gastronomica;



-- 3) 

-- ¿Cuál es el barrio con mayor cantidad de Pubs?

SELECT * FROM oferta_Gastronomica
WHERE Categoria = 'PUB';

UPDATE oferta_gastronomica
SET Categoria = 'Nada'
WHERE Categoria = '' OR ISNULL(Categoria);


-- ESTA QUERY ME DEVUELVE SOLAMENTE LA CANTIDAD DE LOCALES POR BARRIO
SELECT COUNT(IdLocal), Barrio
FROM oferta_gastronomica
GROUP BY Barrio
ORDER BY 1 DESC;


SELECT COUNT(IdLocal), Barrio
FROM oferta_gastronomica
GROUP BY Barrio
HAVING Categoria = 'PUB'
ORDER BY 1 DESC;  -- EL FILTRADO SE HACE EN EL WHERE 

SELECT COUNT(IdLocal), Barrio
FROM oferta_gastronomica
WHERE Categoria = 'PUB'
GROUP BY Barrio
ORDER BY 1 DESC;
-- EL BARRIO CON MAYOR CANTIDAD DE PUB's ES RECOLETA

SELECT COUNT(IdLocal), Barrio
FROM oferta_gastronomica
WHERE Categoria = 'PUB'
GROUP BY Barrio
HAVING COUNT(IdLocal) > 5 -- CUANDO YO QUIERO FILTRAR POR EL CONTEO, O LA FUNCION QUE SE AGRUPA, APLICO UN HAVING
ORDER BY 1 DESC;


-- Obtener la cantidad de locales por categoría

SELECT COUNT(IdLocal) FROM oferta_gastronomica;

SELECT COUNT(IdLocal), Categoria
FROM oferta_gastronomica;
-- Error Code: 1140. In aggregated query without GROUP BY, expression #2 of SELECT list contains nonaggregated column 'henry.oferta_gastronomica.Categoria'; this is incompatible with sql_mode=only_full_group_by


-- Este error me dice que cuando tenga una funcion de agregacion y un campo sin agregacion, debo utilizar GROUP BY en el campo de no agregacion

SELECT COUNT(IdLocal) 'Cantidad', Categoria
FROM oferta_gastronomica
GROUP BY 2 -- Categoria es el campo 2
ORDER BY 1 DESC -- COUNT(IdLocal) es el campo 1 y se ordena de forma descendiente
;

-- LA CATEGORIA CON MAS LOCALES ES RESTAURANTE 

-- Obtener la cantidad de restaurantes por comuna


-- ESTE QUERY NO ESTA FILTRANDO POR CATEGORIA DE RESTAURANTE
SELECT COUNT(IdLocal), Comuna
FROM oferta_gastronomica
GROUP BY Comuna
ORDER BY 1 DESC;


SELECT COUNT(IdLocal), Comuna
FROM oferta_gastronomica
WHERE Categoria = 'RESTAURANTE'
GROUP BY Comuna
ORDER BY 1 DESC;
-- SE APLICA EL FILTRADO DEL WHERE Y NO DEL HAVING, PORQUE ESTOY FILTRANDO POR UNA CONDICION Y NO POR LA AGRAGACION O AGRUPACION

-- 		[1]         [2]
SELECT Comuna, COUNT(IdLocal)
FROM oferta_gastronomica
WHERE Categoria = 'RESTAURANTE'
GROUP BY Comuna
HAVING COUNT(IdLocal) > 150
ORDER BY 2 DESC;
-- SI ME PIDIERAN LAS COMUNAS CON MAS DE 150 RESTAURANTE APLICARIA UN HAVING SOBRE EL CONTEO


-- Como cambiamos el tipo de dato de una columna?

-- ALTER TABLE oferta_gastronomica CHANGE id_local IdLocal INT NOT NULL;

ALTER TABLE oferta_gastronomica CHANGE Comuna Comuna INT ; 
-- DE ESTA FORMA YO CAMBIO EL TIPO DE DATO EN UNA COLUMNA
-- IMPORTANTE!!!! TENER EN CUENTA QUE SI VOY DE VARCHAR A INT O A DECIMAL, TOOOOODOS LOS DATOS DE LA COLUMNA TIENEN QUE PODER MODIFICARSE

-- POR EJ:   VARCHAR '14' -> 14 INT      THIS IS FINE
-- 			VARCHAR 'Comuna 14' -x> Comuna 14 INT   NO VA A PASAR PORQUE EL INT ES SOLAMENTE NUMERICO Y ENTERO
-- 			VARCHAR '38.56'     -> 38.56 DECIMAL DOUBLE FLOAT


-- CLASE DE REPASO



-- JOINS 
-- INNER JOIN 

select * from alumno;
-- IdAlumno CedulaIdentidad Nombre Apellido Fecha_Nacimiento Fecha_Inicio IdCohorte

SELECT * FROM cohorte;
-- IdCohorte Codigo IdCarrera Fecha_Inicio Fecha_Finalizacion IdInstructor


-- INNER JOIN en este caso solo me va a traer las cohortes que tengan alumnos asignados

SELECT a.*, c.*
FROM alumno a INNER JOIN cohorte c     -- ESTABLEZCO DE DONDE VAN A SALIR MIS DATOS, DE LA COMBINACION DE TIPO INNER ENTRE ALUMNO Y COHORTE
			ON (a.IdCohorte = c.IdCohorte) -- NO ES NECESARIO QUE SE LLAMEN IGUAL Y LA RELACION SE PUEDE HACER A LA INVERSA (cohorte.IdCohorte = alumno.IdCohorte)
;
-- HAY QUE DECIRLE A SQL A TRAVES DE QUE COLUMNA VAMOS A RELACIONARNOS

-- siempre que haya un JOIN debe haber un ON (columnas iguales)


SELECT a.*, c.*
FROM alumno a JOIN cohorte c    -- ESTO TAMBIEN ES UN INNER JOIN
		ON (c.IdCohorte = a.IdCohorte);
        


-- Mostrar un listado de alumnos con su cohorte, su IdCarrera y el instructor que tienen asignado

SELECT CONCAT(a.Nombre, ' ',a.Apellido) 'Nombre Completo', a.IdCohorte, c.IdCarrera, c.IdInstructor
FROM alumno a INNER JOIN cohorte c 
				 ON (a.IdCohorte = c.IdCohorte) 
;


-- Mostrar un listado de alumnos, con su cohorte, su nombre de carrera y el IdInstructor

SELECT CONCAT(a.Nombre, ' ',a.Apellido) 'Nombre Completo', a.IdCohorte, c.IdCarrera, ca.Carrera, c.IdInstructor
FROM alumno a INNER JOIN cohorte c 
				 ON (a.IdCohorte = c.IdCohorte) 
	INNER JOIN carrera ca 
				ON (c.IdCarrera = ca.IdCarrera)
;


-- Mostrar un listado de los alumnos, su IdCohorte y el nombre y apellido de su instructor mas su edad

SELECT CONCAT(a.Nombre, ' ',a.Apellido) 'Nombre Alumno', a.IdCohorte, c.IdInstructor, CONCAT(i.Nombre, ' ', i.Apellido) 'Nombre Instructor',
		TIMESTAMPDIFF(YEAR, i.Fecha_Nacimiento, CURDATE()) 'Edad Instructor'
FROM alumno a INNER JOIN cohorte c 
				 ON (a.IdCohorte = c.IdCohorte) 
	INNER JOIN instructor i
				 ON (i.IdInstructor = c.IdInstructor)
;

