-- 1. Проанализировать какие запросы могут выполняться наиболее
-- часто в процессе работы приложения и добавить необходимые индексы.
CREATE INDEX posts_community_id_idx ON posts(community_id);
CREATE INDEX prodiles_birthday_idx ON prodiles(birthday);
CREATE INDEX communities_users_community_id_idx ON communities_users(community_id);
CREATE INDEX communities_users_user_id_idx ON communities_users(user_id);
-- 2. Задание на оконные функции
-- Построить запрос, который будет выводить следующие столбцы:
-- имя группы
-- среднее количество пользователей в группах
-- самый молодой пользователь в группе
-- самый старший пользователь в группе
-- общее количество пользователей в группе
-- всего пользователей в системе
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100
Select DISTINCT
		c2.name
		,count(cu.user_id) over( )/(select  count(*) from communities c3 ) as avg_users
		,FIRST_VALUE(CONCAT( u.first_name, ' ', u.last_name)) over(PARTITION by c2.name order by p.birthday desc) as young_age
		,FIRST_VALUE(CONCAT( u.first_name, ' ', u.last_name)) over(PARTITION by c2.name  order by p.birthday) as old_age
		,count(cu.user_id) over(partition by c2.name ) as all_cnt_users_group
		,count(cu.user_id) over() as all_cnt_users
		,CONCAT(left(count(cu.user_id) over(partition by c2.name )/count(cu.user_id) over()*100,3),'%') as '%%'
From communities c2 
left join communities_users cu 
On c2.id = cu.community_id
left join profiles p 
On cu.user_id = p.user_id 
Left join users u 
ON cu.user_id = u.id ; 
-- 3. (по желанию) Задание на денормализацию
-- Разобраться как построен и работает следующий запрос:
-- Найти 10 пользователей, которые проявляют наименьшую активность 
-- в использовании социальной сети.

SELECT users.id,
COUNT(messages.id) +
COUNT(likes.id) +
COUNT(media.id) AS activity
FROM users
left JOIN messages
ON users.id = messages.from_user_id
left JOIN likes
ON users.id = likes.user_id
left JOIN media
ON users.id = media.user_id
GROUP BY users.id
ORDER BY activity
LIMIT 10;