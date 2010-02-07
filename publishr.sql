CREATE DATABASE IF NOT EXISTS `publishr`;

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
        id            INT(11) AUTO_INCREMENT PRIMARY KEY,
        username      varchar(50) NOT NULL UNIQUE,
        password      varchar(50) NOT NULL,
        email_address varchar(90) NOT NULL,
        first_name    varchar(50) NOT NULL,
        last_name     varchar(50) NOT NULL,
        is_active     INTEGER,
        is_superuser  INTEGER
) CHARACTER SET `utf8` COLLATE `utf8_bin`;


DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
        id          INT(11) AUTO_INCREMENT PRIMARY KEY,
        name        varchar(50) NOT NULL UNIQUE
) CHARACTER SET `utf8` COLLATE `utf8_bin`;

DROP TABLE IF EXISTS `article_tag`;
-- 'article_tag' is a many-to-many join table between article & tags
CREATE TABLE `article_tag` (
        tag_id     INT(11),
        article_id   INT(11),
        PRIMARY KEY (article_id, tag_id)
) CHARACTER SET `utf8` COLLATE `utf8_bin`;

DROP TABLE IF EXISTS `article`;
CREATE TABLE `article`(
        id          INT(11) AUTO_INCREMENT PRIMARY KEY,
        title       varchar(200) NOT NULL,
        body        TEXT,
        user_id     INTEGER NOT NULL,
        insert_date DATETIME NOT NULL,
        update_date DATETIME NOT NULL,
        Foreign Key (user_id) references USER(ID),
        FULLTEXT(title,body)
);


-- SOME DATA
INSERT INTO user VALUES (1, 'admin', 'admin', 'admin@admin.com', 'Admin', 'Boss', 1, 1);
INSERT INTO tag VALUES (1, 'cool');
INSERT INTO tag VALUES (2, 'funny');
INSERT INTO tag VALUES (3, 'bbc');
INSERT INTO tag VALUES (4, 'documentry');
INSERT INTO article VALUES (1, "Getting Started With MySQL's Full-Text Search Capabilities",
"eed a rock-solid, powerful search solution for your PHP/MySQL driven web site? In this article Mitchell introduces us to MySQL's full-text and Boolean search capabilities.In February 2002 I wrote an article called ",
1, "2010-02-02 00:00:00", "2010-02-02 00:00:00");
INSERT INTO article VALUES (2, "Ukraine begins tense presidential election run-off ",
"Ukrainians are voting in a presidential election run-off, after a bruising campaign and warnings of mass street protests and demonstrations. PM Yulia Tymoshenko and opposition leader Viktor Yanukovych are competing for the top job after President Viktor Yushchenko lost out in the first round. Both camps have accused each other of plotting to rig the vote. ",
1, "2010-02-02 00:00:00", "2010-02-02 00:00:00");
INSERT INTO article VALUES (3, "Python is better than perl",
"Ukrainians are voting in a presidential election run-off, after a bruising campaign and warnings of mass street protests and demonstrations. PM Yulia Tymoshenko and opposition leader Viktor Yanukovych are competing for the top job after President Viktor Yushchenko lost out in the first round. Both camps have accused each other of plotting to rig the vote. ",
1, "2010-02-02 00:00:00", "2010-02-02 00:00:00");
INSERT INTO article VALUES (4, "Memory management sucks in Python ",
"Ukrainians are voting in a presidential election run-off, after a bruising campaign and warnings of mass street protests and demonstrations. PM Yulia Tymoshenko and opposition leader Viktor Yanukovych are competing for the top job after President Viktor Yushchenko lost out in the first round. Both camps have accused each other of plotting to rig the vote. ",
1, "2010-02-02 00:00:00", "2010-02-02 00:00:00");
INSERT INTO article_tag VALUES (3, 2);
INSERT INTO article_tag VALUES (4, 2);

