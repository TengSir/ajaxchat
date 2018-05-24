package com.oracle.ajax.control;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.oracle.ajax.model.User;

/**
 * Servlet implementation class UserServlet
 */
@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String method=req.getParameter("method");
		if(method.equals("login"))
		{
			login(req, resp);
		}else if(method.equals("sendMesage"))
		{
			sendMesage(req, resp);
		}else if(method.equals("getMesage"))
		{
			getMesage(req, resp);
		}else if (method.equals("register")) {
			register(req, resp);
		}
	}
	protected void login(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String username=req.getParameter("username");
		String password=req.getParameter("password");
		resp.setContentType("text/json;charset=utf-8");//通过response设置给用户发送的结果类型
		PrintWriter  out=resp.getWriter();
		ArrayList<String> loginedUsers=null;
		if(req.getServletContext().getAttribute("loginedUsers")!=null)//application
		{
			loginedUsers=(ArrayList<String>)req.getServletContext().getAttribute("loginedUsers");
			if(loginedUsers.contains(username)){
				out.write("logined");
				out.flush();
				out.close();
				return;
			}
		}else
		{
			loginedUsers=new ArrayList<>();
		}
		User  user=null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection  c=DriverManager.getConnection("jdbc:mysql://localhost:3306/ajaxChat","root","root");
			Statement sta=c.createStatement();
			ResultSet rs=sta.executeQuery("select *  from t_users where username='"+username+"' and password='"+password+"'");
			JSONArray  users=new JSONArray();
			if(rs.next())
			{
				loginedUsers.add(username);
				user=new User(rs.getInt("userid"),rs.getString("username"),rs.getString("password"),rs.getString("nickname"),rs.getString("sex"),rs.getInt("age"),rs.getString("image"),rs.getString("signature"));
				JSONObject  obj=new JSONObject();
				obj.put("userid", user.getId());
				obj.put("username", user.getUsername());
				obj.put("nickname", user.getNickname());
				obj.put("password", user.getPassword());
				obj.put("sex", user.getSex());
				obj.put("age", user.getAge());
				obj.put("image", user.getImage());
				obj.put("signature", user.getSignature());
				users.put(obj);
				
				
				ResultSet rs1=sta.executeQuery("select *  from  t_users where userid !="+user.getId());
				while(rs1.next())
				{
					User u=new User(rs1.getInt("userid"),rs1.getString("username"),rs1.getString("password"),rs1.getString("nickname"),rs1.getString("sex"),rs1.getInt("age"),rs1.getString("image"),rs1.getString("signature"));
					JSONObject  obj1=new JSONObject();
					obj1.put("userid", u.getId());
					obj1.put("username", u.getUsername());
					obj1.put("nickname", u.getNickname());
					obj1.put("password", u.getPassword());
					obj1.put("sex", u.getSex());
					obj1.put("age", u.getAge());
					obj1.put("image", u.getImage());
					obj1.put("signature", u.getSignature());
					users.put(obj1);
				}
				out.write(users.toString());
			}else
			{
				out.write("error");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		req.getServletContext().setAttribute("loginedUsers",loginedUsers);
		out.flush();
		out.close();
	
	}
	
	/**
	 * 每一个客户端通过聊天界面发送过来的聊天消息都会被后台接受，并且存储到一个application范围的集合里
	 * 服务器不负责推送消息，也就说每个人发过来的消息都会按照顺序放到集合
	 * 但是每个客户端主动再发请求到后台取服务器的消息;
	 * @param req
	 * @param resp
	 * @throws ServletException
	 * @throws IOException
	 */
	protected void sendMesage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String words=req.getParameter("words");
		String user=req.getParameter("user");
		String date=new Date().toLocaleString();
		JSONObject obj=null;
		try {
			obj = new JSONObject(user);
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		try {
			obj.put("date", date);
			obj.put("words", words);
			System.out.println(obj.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		List<JSONObject> messages=null;
		if(req.getServletContext().getAttribute("message")!=null)//application
		{
			messages=(List<JSONObject>)req.getServletContext().getAttribute("message");
		}else
		{
			messages=new ArrayList<JSONObject>();
		}
		if(messages.size()>20)
		{
			messages.remove(0);
		}
		messages.add(obj);
		req.getServletContext().setAttribute("message", messages);
	}
	/**
	 * 这个方法是每个客户端要从服务器上读取别人推送的消息的方法
	 * @param req
	 * @param resp
	 * @throws ServletException
	 * @throws IOException
	 */
	protected void getMesage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("text/json;charset=utf-8");//通过response设置给用户发送的结果类型
		PrintWriter  out=resp.getWriter();
		if(req.getServletContext().getAttribute("message")!=null)
		{
			ArrayList<String> messages=(ArrayList<String>)req.getServletContext().getAttribute("message");
			JSONArray  ms=new JSONArray(messages);//如果服务器有消息，则将读取出来的消息封装成json字符串数组，发送给客户端
			out.write(ms.toString());
		}
		out.flush();
		out.close();
	}
	
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req, resp);
	}

protected void register(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String username = req.getParameter("username");
		String password = req.getParameter("password");
		String nickname = req.getParameter("nickname");
		String sex = req.getParameter("sex");
		String age = req.getParameter("age");
		String signature = req.getParameter("signature");
		String image = req.getParameter("image");
		int flag=0;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection c = DriverManager.getConnection("jdbc:mysql://localhost:3306/ajaxChat", "root", "root");
			Statement sta = c.createStatement();
			flag=sta.executeUpdate("insert into t_users values(null,'"+username+"','"+nickname+"','"+password+"','"+signature+"','"+sex+"',"+age+",'"+image+"')");
		} catch (Exception e) {
			e.printStackTrace();
		}

		resp.setContentType("text/json;charset=utf-8");
		PrintWriter out = resp.getWriter();
		if(flag>0){
			out.write("true");
		}
		System.out.println(flag);
		out.flush();
		out.close();

	}

}
