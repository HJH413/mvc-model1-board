<%@ page import="com.board.repository.BoardDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    BoardDAO boardDAO = new BoardDAO();

    int commentsNum = Integer.parseInt(request.getParameter("commentsNum"));
    String commentsPassword = request.getParameter("commentsPassword");

    int check = boardDAO.commentsStateUpdate(commentsNum, commentsPassword);
    if(check == 0){ %>
        <script>
            alert("비밀번호 불일치");
        </script>
    <% }  %>
