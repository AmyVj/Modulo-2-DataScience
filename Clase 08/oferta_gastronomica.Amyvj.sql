use test;

SET SQL_SAFE_UPDATES = 0; -- Desactivar el modo seguro de actualización temporalmente


UPDATE oferta_gastronomica
SET barrio = 'NuÃƒÆ’Ã‚Â±ez'
WHERE barrio = 'Nuñez';

SET SQL_SAFE_UPDATES = 1; -- Volver a activar el modo seguro de actualización


#Barrio con más pubs
SELECT categoria, barrio, COUNT(*) AS cantidad
FROM oferta_gastronomica
WHERE categoria = 'PUB'
GROUP BY barrio, categoria
ORDER BY cantidad DESC
LIMIT 0, 1000;


#Locales por rubro
SELECT categoria, COUNT(*) AS cantidad
from oferta_gastronomica
GROUP BY categoria
ORDER BY cantidad DESC;

#Resto por comuna
SELECT comuna, COUNT(*) AS cantidad
from oferta_gastronomica
GROUP BY comuna, categoria
HAVING categoria = 'RESTAURANTE'
ORDER BY cantidad DESC;
