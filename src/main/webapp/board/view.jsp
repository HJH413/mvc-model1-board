<%@ page import="com.board.repository.BoardDAO" %>
<%@ page import="com.board.dto.CategoryDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.board.dto.BoardDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    BoardDAO boardDAO = new BoardDAO();
    BoardDTO boardDTO = new BoardDTO();

    //int boardNum = Integer.parseInt(request.getParameter("boardNum"));
    boardDAO.boardHits(3);
    boardDTO = boardDAO.boardView(3);
    List<BoardDTO> boardFileList = boardDAO.boardFileList(3);

    int boardNum = boardDTO.getBoardNum();
    String boardWriter = boardDTO.getBoardWriter();
    String boardTittle = boardDTO.getBoardTittle();
    String boardContent = boardDTO.getBoardContent();
    String categoryName = boardDTO.getCategoryName();
    int boardHits = boardDTO.getBoardHits();
    String boardRegisterDate = boardDTO.getBoardRegisterDate().substring(0, boardDTO.getBoardRegisterDate().length() - 3);
    String boardUpdateDate = boardDTO.getBoardUpdateDate();

    if (boardUpdateDate == null) {
        boardUpdateDate = "-";
    } else {
        boardUpdateDate.substring(0, boardUpdateDate.length() - 3);
    }

    List<BoardDTO> boardCommentsList = boardDAO.boardCommentsList(3);
%>

<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>게시판 - 보기</title>

    <%@ include file="include/source.jsp" %>
    <script type="text/javascript">

    $(function () {
        $('#commentsSave').on("click", function () {
            let commentsForm = $("#commentsForm").serialize();

            if($('#commentsWriter').val() ==''){
                alert("댓글 작성자 입력")
                return false;
            }
            if($('#commentsPassword').val() ==''){
                alert("댓글 비밀번호 입력")
                return false;
            }
            if($('#commentsContent').val() ==''){
                alert("댓글 내용 입력")
                return false;
            }

            $.ajax({
                type: "post",
                url: "./api/saveComments.jsp",
                data: commentsForm,
                success: function (data) {
                    console.log("댓글 작성 완료");
                },
                error: function (request, status, error) {
                    console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                },
                complete: function () {
                    location.reload();
                }
            });
        });
    });

    </script>
</head>
<body>
<div class="container-fluid">
    <div class="row justify-content-md-center">
        <div class="col-md-auto">
            <div class="h1"> 게시판 - 보기</div>
        </div>
    </div>
    <br/>
    <br/>
    <div class="card">
        <div class="card-body">
            <div class="row">
                <div class="col-sm-1">
                    <%= boardWriter %>
                </div>
                <div class="col-sm-7">
                </div>
                <div class="col-sm-2">
                    등록일 <%= boardRegisterDate  %>
                </div>
                <div class="col-sm-2">
                    수정일 <%= boardUpdateDate  %>
                </div>
                <br/>
                <div class="col-sm-11">
                    <div class="h2">[<%= categoryName %>] <%= boardTittle %>
                    </div>
                </div>
                <div class="col-sm-1">
                    조회수 : <%= boardHits %>
                </div>
                <div class="col-sm-12">
                    <label for="boardContent" class="col-form-label"></label>
                    <textarea class="form-control" id="boardContent" name="boardContent" rows="7"
                              readonly><%= boardContent %></textarea>
                </div>
            </div>
            <br/>
            <br/>
            <div class="col-sm-12">
                <%
                    for (BoardDTO boardFileDTO : boardFileList) {
                %>
                <a href="../file/<%=boardFileDTO.getFileUuidName()%>" download=""><%=boardFileDTO.getFileOriginName()%>
                </a><br/>
                <%
                    }
                %>
            </div>
        </div>
        <br/>
        <br/>
        <div class="card">
            <div class="card-body">
                <div><%--댓글 내용--%>
                    <div id="commentsListDiv">
                        <% if(boardCommentsList == null) { %>
                        작성된 댓글이 없습니다.
                        <% } else { %>
                        <%
                            for (BoardDTO comments : boardCommentsList){
                        %>
                        <div class="row justify-content-between">
                            <div class="col-sm-2">
                                <label for="commentsContent1" class="form-label"><%= comments.getCommentsWriter()%> <%= comments.getCommentsRegisterDate()%></label>
                            </div>
                            <div class="col-sm-2">
                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <button class="btn btn-danger" type="button">삭제</button>
                                </div>
                            </div>
                        </div>
                        <div class="input-group mb-3">
                            <input type="text" id="commentsContent1" class="form-control-plaintext" placeholder="댓글 내용" value="<%=comments.getCommentsContent()%>"
                                   readonly>
                        </div>
                        <hr/>
                        <%
                            }
                        %>
                        <% } %>
                    </div>
                    <nav aria-label="Page navigation example">
                        <ul class="pagination">
                            <li class="page-item">
                                <a class="page-link text-dark" href="#" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            <li class="page-item"><a class="page-link text-dark" href="#">1</a></li>
                            <li class="page-item"><a class="page-link text-dark" href="#">2</a></li>
                            <li class="page-item"><a class="page-link text-dark" href="#">3</a></li>
                            <li class="page-item">
                                <a class="page-link text-dark" href="#" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                    <hr/>
                    <form id="commentsForm">
                        <input type="hidden" name="boardNum" id="boardNum" value="<%=boardNum%>">
                        <div class="mb-1 row">
                            <label for="commentsWriter" class="col-sm-1 col-form-label">작성자 : </label>
                            <div class="col-sm-2">
                                <input type="text" class="form-control" id="commentsWriter" name="commentsWriter"
                                       minlength="4" maxlength="5" required>
                            </div>
                            <label for="commentsPassword" class="col-sm-1 col-form-label">비밀번호 : </label>
                            <div class="col-sm-2">
                                <input type="password" class="form-control" id="commentsPassword"
                                       name="commentsPassword"
                                       minlength="4" maxlength="15"
                                       required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-10">
                                <div class="form-floating">
                                    <textarea class="form-control" placeholder="Leave a comment here"
                                              id="commentsContent" name="commentsContent" rows="3"></textarea>
                                    <label for="commentsContent">댓글을 입력해 주세요.</label>
                                </div>
                            </div>
                            <div class="col-sm-2">
                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <button class="btn btn-info" id="commentsSave" type="button" >등록</button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<br/>
<br/>
<div class="row justify-content-center">
    <div class="col-sm-2">
        <div class="d-grid gap-2">
            <button class="btn btn-secondary" type="button" onclick="location.href='/'">목록</button>
        </div>
    </div>
    <div class="col-sm-2">
        <div class="d-grid gap-2">
            <button class="btn btn-info" type="button" onclick="location.href='./modify.jsp'">수정</button>
        </div>
    </div>
    <div class="col-sm-2">
        <div class="d-grid gap-2">
            <button class="btn btn-danger" type="button">삭제</button>
        </div>
    </div>
</div>
</body>
</html>
