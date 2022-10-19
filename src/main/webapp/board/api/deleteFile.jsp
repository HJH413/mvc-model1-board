<%@ page import="com.board.repository.BoardDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    BoardDAO boardDAO = new BoardDAO();

    int boardNum = Integer.parseInt(request.getParameter("boardNum"));
    int fileNum = Integer.parseInt(request.getParameter("fileNum"));

    boardDAO.fileStateUpdate(fileNum);
    boardDAO.boardFileStateUpdate(boardNum);
%>