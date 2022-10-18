<%@ page import="com.board.repository.BoardDAO" %>
<%@ page import="com.board.dto.BoardDTO" %>
<%@ page import="java.util.UUID" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  BoardDTO boardDTO = new BoardDTO();
  BoardDAO boardDAO = new BoardDAO();

  String boardWriter = request.getParameter("boardWriter");
  String boardPassword = request.getParameter("boardPassword");
  String boardTitle = request.getParameter("boardTitle");
  String boardContent = request.getParameter("boardContent");
  int categoryNum = Integer.parseInt(request.getParameter("categoryNum"));


  boardDTO.setBoardWriter(boardWriter);
  boardDTO.setBoardPassword(boardPassword);
  boardDTO.setBoardTittle(boardTitle);
  boardDTO.setBoardContent(boardContent);
  boardDTO.setBoardUuid(UUID.randomUUID().toString());
  boardDTO.setCategoryNum(categoryNum);

  boardDAO.boardWriter(boardDTO);

%>