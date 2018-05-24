use  ajaxchat;

create table t_users
(
	userid int   primary key  auto_increment,
	username varchar(20) not null,
	nickname varchar(20) not null,
	password varchar(20)  not null,
	signature varchar(2000) default '没有个性签名',
	sex  char(2) ,
	age int ,
	image  varchar(200)
)charset=utf8;
use ajaxchat ;select  * from  t_users;
truncate table  t_users;
insert into t_users values(null,'admin','群主','123456','没有个性哪有个性签名','男',20,'images/115.gif');
insert into t_users values(null,'mayun','马云','123456','没有个性哪有个性签名','男',21,'images/116.gif');
insert into t_users values(null,'wangsicong','王思聪','123456','没有个性哪有个性签名','男',22,'images/117.gif');
insert into t_users values(null,'wangbaoqiang','宝宝','123456','没有个性哪有个性签名','男',23,'images/118.gif');
insert into t_users values(null,'marong','宝宝前宝宝','123456','没有个性哪有个性签名','女',24,'images/119.gif');

create table  user_relations
(
	userid int  ,
	friendid int,  primary key(userid,friendid)
)charset=utf8;

insert into  user_relations values(1,2);
insert into  user_relations values(1,3);
insert into  user_relations values(1,4);
insert into  user_relations values(1,5);
insert into  user_relations values(2,1);
insert into  user_relations values(2,3);
insert into  user_relations values(2,4);
insert into  user_relations values(5,1);
