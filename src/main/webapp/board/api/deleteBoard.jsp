<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--패키지 가져오기--%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.board.repository.BoardDAO" %>

<%
    int boardNum = Integer.parseInt(request.getParameter("board_num"));
    String boardPassword = request.getParameter("board_password");
    BoardDAO boardDAO = new BoardDAO();
    int check = boardDAO.boardPasswordCheck(boardNum, boardPassword); //삭제 실패시 0 성공하면 1
    System.out.println(check);
    if(check == 0){ %>
    <script>
        alert("비밀번호 불일치");
        location.href= "/board/view.jsp?boardNum="+<%=boardNum %>;
    </script>
    <% } else {
        boardDAO.boardStateUpdate(boardNum);
        System.out.println(check +" passCheckNum@@#@#");
        response.sendRedirect("/board/list.jsp");
    } %>
