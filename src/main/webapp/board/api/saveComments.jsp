<%@ page import="com.board.dto.BoardDTO" %>
<%@ page import="com.board.repository.BoardDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    BoardDTO boardDTO = new BoardDTO();
    BoardDAO boardDAO = new BoardDAO();

    boardDTO.setCommentsWriter(request.getParameter("commentsWriter"));
    boardDTO.setCommentsPassword(request.getParameter("commentsPassword"));
    boardDTO.setCommentsContent(request.getParameter("commentsContent"));
    boardDTO.setBoardNum(Integer.parseInt(request.getParameter("boardNum")));

    boardDAO.boardCommentsWrite(boardDTO);
%>