<%@ page import="com.board.repository.BoardDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    BoardDAO boardDAO = new BoardDAO();

    int commentsNum = Integer.parseInt(request.getParameter("commentsNum"));
    String commentsPassword = request.getParameter("commentsPassword");

    boardDAO.commentsStateUpdate(commentsNum, commentsPassword);
%>