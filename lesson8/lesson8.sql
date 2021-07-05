-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
Select b.gender
	,count(a.id) as cnt_id
From likes a
JOIN profiles b
ON a.user_id = b.user_id
Group by b.gender
Order by cnt_id desc limit 1;


-- 4. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
Select 
		Count(*)
From likes l
JOIN profiles p
ON l.target_id = p.user_id 
Where l.target_type_id = 2 
Order by p.birthday DESC limit 10;

-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети (критерии активности необходимо определить самостоятельно).

Select CONCAT(first_name ,' ',last_name) as name_user
	,count(m.id) + count(p.id) + count(l.id) as cnt_activ
From users u 
LEFT JOIN messages m 
ON u.id = m.from_user_id 
LEFT JOIN posts p 
ON u.id = p.user_id 
LEFT JOIN likes l 
ON u.id = l.user_id 
Group by name_user
Order by cnt_activ desc limit 10;