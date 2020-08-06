-- 2. Таблица лайков
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');

-- Заполняем лайки
INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 100)), 
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + (RAND() * 4)),
    CURRENT_TIMESTAMP 
  FROM messages;
 -- таблица постов
DROP TABLE IF EXISTS `posts`;

CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  views_counter INT UNSIGNED DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


UPDATE posts SET updated_at = CURRENT_TIMESTAMP() where created_at > updated_at ;
-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
Select (select distinct gender from profiles where user_id = likes.user_id) as gender
		,count(id) as cnt
From likes
Group by 
		gender
Order by cnt desc;

-- 4. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
SELECT 
		count(id) as sum_l
		,(select birthday from profiles where user_id =likes.user_id ) as birthday
		,(select user_id from profiles where user_id =likes.user_id) as user_id 
From likes 
Group by birthday
			,user_id 
Order by birthday desc limit 10;
-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети (критерии активности необходимо определить самостоятельно).

Select 
		id
		,(select count(id) from messages where from_user_id = users.id group by from_user_id ) as cnt_mes
		,(select count(id) from posts where user_id = users.id group by user_id ) as cnt_post
From users
Order by cnt_mes DESC, cnt_post desc limit 10;