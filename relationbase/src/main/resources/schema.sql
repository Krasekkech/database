--SQL


-- INSERT INTO TEST(username)values('Kamil');
create table userr(
                      id varchar(255) primary key,
                      username varchar(20),
                      birthdate date
);

create table articles(
                         id varchar(255) primary key ,
                         author_id char(255),
                         article_name varchar(20),
                         article_date varchar(255)
);
create table comments(
                         id varchar(255) primary key ,
                         user_id varchar(255),
                         comment_date char(20),
                         article_id varchar(255),
                         foreign key (article_id) references articles(id),
                         foreign key (user_id) references userr(id)
);

create table likes(
                      user_id varchar(255),
                      comment_id varchar(255),
                      like_date char(20),
                      foreign key (comment_id) references comments(id),
                      foreign key (user_id) references userr(id)

);








alter table userr rename to "user";
alter table articles rename column article_date to article_date_published;
alter table articles alter column article_date_published type char(20);
alter table "user" alter column id set not null;
alter table "user" add constraint uk unique(id);

