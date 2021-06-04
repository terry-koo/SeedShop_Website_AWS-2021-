<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*" %>
<%@page import="java.sql.Date" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="database.Data" %>


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식물데이터 저장</title>
<link rel="shortcut icon" href="images/favicon.ico" />
</head>
<body>
<%! int plantid; %>



<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	PreparedStatement pstmt2 = null;
    PreparedStatement pstmtSelect = null; 
	
	String url = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "seedshop";
	String pass = "seedshop001";
	
	try{
	request.setCharacterEncoding("utf-8");
	
	plantid = 1;
	String plantname = request.getParameter("plantname");
	int price = Integer.parseInt(request.getParameter("price"));
	int cost = Integer.parseInt(request.getParameter("cost"));
	int sow = Integer.parseInt(request.getParameter("sow"));
	String company = request.getParameter("company");
	String country = request.getParameter("country");
	
	
 	
	
		
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(Data.url, Data.user, Data.pass);
		//오토커밋 false로 지정
		conn.setAutoCommit(false); 	
		
		///현재 데이터베이스에 저장된 plantid중 최대값을 확인하여 중복된 plantid가 데이터베이스에 저장되지 않게
		String plantsql = "select plantid  from (select plantid from plant order by plantid desc) where rownum<=1";
		pstmtSelect = conn.prepareStatement(plantsql);
		ResultSet rs = pstmtSelect.executeQuery(); 
		
	 	while (rs.next())
		{
			 plantid = rs.getInt(1)+1;
		} 
		rs.close();
		
				
		//데이터베이스에 데이터 입력
		pstmt = conn.prepareStatement("insert into plant(plantid, plantname, price, sow)"+"values(?,?,?,?)"); 
		pstmt.setInt(1,plantid);
		pstmt.setString(2,plantname);
		pstmt.setInt(3,price);
		pstmt.setInt(4,sow);
		pstmt.executeUpdate();
	
		
		pstmt2 = conn.prepareStatement("insert into plantcompany(plantid, company, country, cost)"+"values(?,?,?,?)");
		pstmt2.setInt(1,plantid);
		pstmt2.setString(2,company);
		pstmt2.setString(3,country);
		pstmt2.setInt(4,cost);
		pstmt2.executeUpdate();
		conn.commit();
		
	}catch(Exception e){
		//예외발생시 rollback
		if(conn!=null){conn.rollback();}
		e.printStackTrace();
		%>
			<script>
				alert("올바른 값을 입력하시오");
				document.location.href="/seedshop/home/SeedManageForm.jsp"
			</script>
		<%
	}finally{
		try{
			conn.setAutoCommit(true);
			if(pstmt != null) pstmt.close();
			if(pstmtSelect != null) pstmtSelect.close();
			if(conn != null) conn.close();			
		}catch(Exception e){
				
		}
	}
%>

<script>
alert("모종 데이터 입력 성공")
document.location.href="/seedshop/home/SeedManageForm.jsp"
</script>




</body>
</html>