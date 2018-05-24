<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>XXxxx</title>
<script type="text/javascript" src="jquery.min.js"></script>
<script type="text/javascript" src="Json.js"></script>
<script type="text/javascript">
	function showChat() {
		if ($("#status").val() == 0) {
			$("#loginFrame").css("display", "block");
		} else {
			$("#chatFrame").css("display", "block");
		}
	}
	function showRegister(){
		$("#registerFrame").css("display", "block");
		$("#loginFrame").css("display", "none");
	}
	function registerUser(){
		var  username=$("#usernameForRegister").val();
		var  password=$("#passwordForRegister").val();
		var  nickname=$("#nickname").val();
		var  sex=$("#sex").val();
		var  age=$("#age").val();
		var  signature=$("#signature").val();
		var image=$("#head").attr("src");
		$.post("UserServlet?method=register",{
			"username":username,
			"password":password,
			"nickname":nickname,
			"sex":sex,
			"age":age,
			"signature":signature,
			"image":image
			},
			function(data){
			if(data==true){
// 				alert(data);
				showLogin();
			}
		});
	}
	function selectImage(){
		$("#imageFrame").css("display","block");
		
	}
	function changeImage(src){
		$("#imageFrame").css("display","none");
		$("#head").attr("src",src);
	}
	function showLogin(){
		$("#registerFrame").css("display", "none");
		$("#loginFrame").css("display", "block");
	}
	function login(){
		var  username=document.getElementById("username").value;
		var password=$("#password").val();
		//alert(username+"\t"+password);
		var xhr=new XMLHttpRequest();//
		xhr.onreadystatechange=function(){
			if(xhr.readyState==4)
			{
					if(xhr.status==200)
					{
					
						if(xhr.responseText=='logined')
						{
							alert('该账号已经登陆，不能重复登陆!');	
						}else if(xhr.responseText=='logined')
						{
							alert('用户名和密码不正确!');	
						}else
						{
							//登陆成功后下面这一段是读取后台发送过来的用户信息和好友资料
							$("#loginFrame").css("display", "none");
							$("#chatFrame").css("display", "block");
							var users=JSON.parse(xhr.responseText);
							$("#selfInfo").html("<div style='height:30px;margin-top:5px;border-radius:5px;text-align:left;padding-left:0px;' onmouseover=this.style.backgroundColor='#eeeeee'  onmouseout=this.style.backgroundColor=''><img src='"+users[0].image+"' width='20' height='20' style='position:relative;top:5px;' /><span style='font-size:12px;'>["+users[0].nickname+"]\""+users[0].username+"\"</span></div>");
							$("#status").val(1);
							$("#myself").val(JSON.stringify(users[0]));
							for(var n=1;n<users.length;n++)
							{
								$("#friendsInfo").append("<div style='width:160px;height:30px;margin-top:5px;border-radius:5px;text-align:left;padding-left:0px;float:left' onmouseover=this.style.backgroundColor='#eeeeee'  onmouseout=this.style.backgroundColor=''><img src='"+users[n].image+"' width='20' height='20' style='position:relative;top:5px;' /><span style='font-size:12px;'>["+users[n].nickname+"]\""+users[n].username+"\"</span></div>");
							}
							//要开启一个定时器周期性的到后台读取服务器已经推送的消息
							setInterval("loadMessage()",1000);	
						}
					}
			}
			
		};//当请求发送到后台后，后台执行完毕之后前台应该回掉的函数
		xhr.open("get","UserServlet?method=login&username="+username+"&password="+password);
		xhr.send(null);
	}
	function loadMessage(){
		$.post("UserServlet","method=getMesage",function(data){
			$("#messages").html("");
			for(var  n=0;n<data.length;n++)
			{
				$("#messages").append("<img src='"+data[n].image+"' width='20' height='20' style='position:relative;top:5px;' /><span style='font-size:12px;'>["+data[n].nickname+"]\""+data[n].username+"\"</span>&nbsp;&nbsp;&nbsp;");
				$("#messages").append(data[n].date+"<br/>"+data[n].words+"<br/><br/>");
				document.getElementById('messages').scrollTop=document.getElementById('messages').scrollHeight;
			}
		});
	}
	function sendMessage(){
		//	$("#messages").append($("#selfInfo").html()+"&nbsp;&nbsp;&nbsp;"+new Date().toLocaleString()+"<br/>"+$("#editMessage").val()+"<br/><br/>");
			//document.getElementById('messages').scrollTop=document.getElementById('messages').scrollHeight;
			//ajax发送出去
			$.post("UserServlet","method=sendMesage&words="+$("#editMessage").val()+"&user="+$("#myself").val(),function(data){
				$(document).attr("title","消息已经发送了!");
			});
			$("#editMessage").val("");
	}
	function keySend(){
		if(event.keyCode==13)
			{
			sendMessage();
			}
		
	}
	

</script>
</head>
<body>
	<input type="hidden" id="status" value="0">
	<input type="hidden"  id="myself" value=""/>
	<div id="loginFrame"
		style="border: 1px solid deepskyblue; width: 400px; height: 200px; position: absolute; left: 500px; top: 284px; border-radius: 10px; display: none;text-align: center;">
		<table style="margin-left: 60px;margin-top: 50px;">
			<tr>
				<td>username:</td>
				<td><input type="text" id="username"  value="mayun"/></td>
			</tr>
			<tr>
				<td>password:</td>
				<td><input type="password" id="password"  value="123456"/></td>
			</tr>
			<tr>
				<td><input type="button" value="login"  onclick="login()"/></td>
				<td><input type="button" value="register"  onclick="showRegister()"/></td>
			</tr>
		</table>
	</div>
	
	<div id="registerFrame"
		style="border: 1px solid deepskyblue; width: 400px; height: 360px; position: absolute; left: 500px; top: 204px; border-radius: 10px; display: none;text-align: center;">
		<table style="margin-left: 60px;margin-top: 20px;">
			<tr>
				<td>username:</td>
				<td><input type="text" id="usernameForRegister" /></td>
			</tr>
			<tr>
				<td>nickname:</td>
				<td><input type="text" id="nickname" /></td>
			</tr>
			<tr>
				<td>password:</td>
				<td><input type="password" id="passwordForRegister" /></td>
			</tr>
			<tr>
				<td>user-sex:</td>
				<td>
					<select  id="sex" style="width: 170px;">
					<option value="男">男</option>
					<option value="女">女</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>user-age:</td>
				<td>
					<select  id="age" style="width: 170px;">
						<script type="text/javascript">
							for(var n=1;n<=100;n++)
								{
									document.write("<option  value='"+n+"'>"+n+"岁</option>");
								}
						</script>
					</select>
				</td>
			</tr>
			<tr>
				<td valign="top">userHead:</td>
				<td>
					<img id="head"  src="images/1.gif" width="20"  height="20" style="position: relative;top: 5px;" /><input type="button"  onclick="selectImage()" value="change"/>
				</td>
			</tr>
			<tr>
				<td  valign="top">signature:</td>
				<td><textarea  id="signature"  style="width: 170px;height: 100px;"></textarea> </td>
			</tr>
			<tr>
				<td><input type="button" value="register" onclick="registerUser()" /></td>
				<td><input type="button" value="login" onclick="showLogin()" /></td>
			</tr>
		</table>
	</div>
	
	<div id="imageFrame"  style="border: 1px solid deepskyblue; width: 800px; height: 400px; position: absolute; left: 300px; top: 184px; border-radius: 10px; display: none;text-align: center;z-index: 10;background-color: lightskyblue">
		<table>
						<tr>
							<script type="text/javascript">
								 var m=1;
								for(var n=1;n<137;n++)
									{
										document.write("<td><img src='images/"+n+".gif' width='30' height='30'/><input type='radio'  onclick='changeImage(this.value)' value='images/"+n+".gif' /></td>");
										if(m%20==0)
											document.write("</tr><tr>");
										m++;
									}
							</script>
						</tr>
					</table>
	</div>

	<div id="chatFrame"
		style="width: 600px; height: 400px; border: 1px solid deepskyblue; border-radius: 10px; display: none; position: absolute; left: 300px; top: 184px; padding: 10px;">
		<table>
			<tr>
				<td>
					<div  id="messages"
						style="width: 400px; height: 200px; margin-bottom: 20px; float: left;border: 1px dotted deepskyblue; border-radius: 10px;overflow: scroll;overflow-x:hidden">
					</div>
				</td>
				<td rowspan="3" align="center">
					<div
						style="width: 170px; height: 390px; float: left; border: 1px dotted deepskyblue; border-radius: 10px; margin-left: 15px;">
						<div  id="selfInfo"></div>
						<hr/>
						<div id="friendsInfo" style="height: 330px;overflow: scroll;overflow-x:hidden;">
						</div>
						</div>
				</td>
			</tr>
			<tr>
				<td>
					<div
						style="width: 400px; height: 130px; margin-bottom: 20px; float: top;">
						<textarea  id="editMessage"  onkeyup="keySend()"
							style="width: 100%; height: 100%; border: 1px dotted deepskyblue; border-radius: 10px;"></textarea>
					</div>
				</td>
			</tr>
			<tr>
				<td align="right" valign="top"><input type="button"
					value="send"  onclick="sendMessage()"/> <input type="button" value="exit" /></td>
			</tr>
		</table>
	</div>

	<div onclick="showChat()"
		style="position: absolute; left: 1200px; top: 600px; width: 100px; height: 100px; border-radius: 50px; text-align: center; vertical-align: middle; font-size: 15px; background-color: pink; color: purple; cursor: pointer;">
		<img src="images/chat.jpg" width="100" height="100" />
	</div>
</body>
</html>