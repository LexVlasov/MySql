-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

Select a.name
	,Count(b.orders)
From users a
JOIN orders b
ON a.id = b.user_id
Group by a.name
Having COUNT(b.orders) >=1;

--  2. Выведите список товаров products и разделов catalogs, который соответствует товару.

Select a.name
	,b.section
From products a
LEFT JOIN catalogs b
ON a.id = b.product_id;

-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

Select
	a.id
	,b.name as from
	,c.name as to
From flights a
LEFT JOIN cities b
ON a.from = b.label
LEFT JOIN cities c
ON a.to = c.label;	