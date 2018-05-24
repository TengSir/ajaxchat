use  ajaxchat;

create table t_users
(
	userid int   primary key  auto_increment,
	username varchar(20) not null,
	nickname varchar(20) not null,
	password varchar(20)  not null,
	signature varchar(2000) default 'û�и���ǩ��',
	sex  char(2) ,
	age int ,
	image  varchar(200)
)charset=utf8;
use ajaxchat ;select  * from  t_users;
truncate table  t_users;
insert into t_users values(null,'admin','Ⱥ��','123456','û�и������и���ǩ��','��',20,'images/115.gif');
insert into t_users values(null,'mayun','����','123456','û�и������и���ǩ��','��',21,'images/116.gif');
insert into t_users values(null,'wangsicong','��˼��','123456','û�и������и���ǩ��','��',22,'images/117.gif');
insert into t_users values(null,'wangbaoqiang','����','123456','û�и������и���ǩ��','��',23,'images/118.gif');
insert into t_users values(null,'marong','����ǰ����','123456','û�и������и���ǩ��','Ů',24,'images/119.gif');

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
