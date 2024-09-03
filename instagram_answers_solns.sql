USE instagram;

-- find 5 oldest users -> extract time data from timestamp
-- SELECT username FROM users ORDER BY created_at DESC LIMIT 5 ;

-- what day of the week do most users register on
-- select count(*), dayname(created_at) from users group by dayname(created_at);

-- find users who have NEVER posted a photo -> select all user ids not in photo
-- SELECT username FROM users WHERE id NOT IN (SELECT user_id FROM photos);

-- ~ find the most liked photo
/*
SELECT photo_id, photos.image_url, username, COUNT(photo_id) FROM likes 
	INNER JOIN photos ON likes.photo_id = photos.id 
    INNER JOIN users ON photos.user_id = users.id
    GROUP BY photo_id ORDER BY COUNT(photo_id) DESC LIMIT 1;
*/

-- * average times a user posts -> TOTAL PHOTOS / TOTAL USERS
-- SELECT (SELECT COUNT(*) FROM PHOTOS)/(SELECT COUNT(*) FROM USERS) AS avg_post_per_user;

-- top 5 hashtags
/*
select tag_id, count(tag_id), tags.tag_name from photo_tags 
inner join tags on tags.id = photo_tags.tag_id
group by tag_id order by count(tag_id) desc limit 5 ;
*/

-- find all users who liked ALL photos on site
-- select count(*) from photos;
/*
select username, count(user_id) as user_count from likes
inner join users on users.id = likes.user_id
group by user_id 
having ((select count(*) from photos) = user_count);
*/

/*
Preventing self follows on instagram
DELIMITER $$

CREATE TRIGGER prevent_self_followees
	BEFORE INSERT ON follows FOR EACH ROW
	BEGIN
		IF NEW.follower_id = NEW.followee_id
		THEN
			SIGNAL SQLSTATE'45000'
			SET MESSAGE_TEXT = 'Cannot self-follow'
		END IF;
	END;

$$ DELIMITER;
*/
/*
Logging Unfollows
1 - Create a unfollows table
CREATE TABLE unfollows(
    follower_id INTEGER NOT NULL,
    followee_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (follower_id) REFERENCES users(id),
    FOREIGN KEY (followee_id) REFERENCES users(id),
    PRIMARY KEY (follower_id, followee)id)
);

2 - Create a trigger for unfollows
DELIMITER $$
CREATE TRIGGER create_unfollow
	AFTER DELETE ON follows FOR EACH ROW
	BEGIN
        INSERT INTO unfollows
        SET follower_id = OLD.follower_id, followee_id = OLD.followee_id;
	END$$ 
DELIMITER;
*/
-- To list all triggers, use SHOW TRIGGERS; the same way SHOW DATABASES; is used
-- To delete triggers, use DROP TRIGGER trigger_name; the same way DROP TABLE table_name; is used
-- Note that Triggers make debugging more difficult

/*
-- INDEXES: Find values from columns faster
-- 	PRO:	Scales very good (less resource loss when querying longer columns), SELECT faster
-- 	CON:	UPDATE slower

-- to make an INDEX (multi-column b-tree index, specifically)
CREATE INDEX find_comments ON comments (photo_id, user_id);

-- on SHOW INDEX;, find_comments shows 2 indexes: find_comments(photo_id) as priority 1, and find_comments(user_id) as priority 2
-- to compare performance speed, try: EXPLAIN [SELECT statement here] which outputs time take and rows scanned
-- use for tables that remain STATIC for a LONG TIME

-- to make a functional index
-- use when functions/subqueries are needed for indexes e.g. (( month(time_column) ))
-- TWO parenthesis () are used because one is needed for the INDEX and another is needed for the expression/function

ALTER TABLE demo_table
ADD INDEX demo_index (expression);
-- output here will be less rows covered and compared with a normal index, time taken decreases with size of database
*/