<%@ page import="com.board.repository.BoardDAO" %>
<%@ page import="com.board.dto.BoardDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    BoardDAO boardDAO = new BoardDAO();
    BoardDTO boardDTO = new BoardDTO();

    int boardNum = Integer.parseInt(request.getParameter("boardNum"));
    boardDTO = boardDAO.boardView(boardNum);
    String boardWriter = boardDTO.getBoardWriter();
    String boardTittle = boardDTO.getBoardTittle();
    String boardContent = boardDTO.getBoardContent();
    String categoryName = boardDTO.getCategoryName();
    int boardHits = boardDTO.getBoardHits();
    String boardRegisterDate = boardDTO.getBoardRegisterDate().substring(0, boardDTO.getBoardRegisterDate().length() - 3);
    String boardUpdateDate = "";

    if(boardDTO.getBoardUpdateDate() != null){
        boardUpdateDate = boardDTO.getBoardUpdateDate().substring(0, boardDTO.getBoardUpdateDate().length() - 3);
    } else {
        boardUpdateDate = "-";
    }

    List<BoardDTO> boardFileList = boardDAO.boardFileList(boardNum);
    int boardFileSize = boardFileList.size();
%>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>게시판 - 수정</title>
    <%@ include file="include/source.jsp" %>
    <script>

        const boardModifyFormCheck = () => {
            if(document.getElementById('boardPassword').value === '') {
                alert("비밀번호 입력하세요.");
                return false;
            }
        }


        const fileStateModify = (fileNum) => {

            confirm("파일 삭제?")

            let fileNumId = 'fileNum' + fileNum;

            let data = {
                boardNum: document.getElementById('boardNum').value,
                fileNum: document.getElementById(fileNumId).value
            }

            $.ajax({
                type: "post",
                url: "./api/deleteFile.jsp",
                data: data,
                success: function (data) {
                    console.log("파일 삭제 완료");
                },
                error: function (request, status, error) {
                    console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                },
                complete: function () {
                    location.reload();
                }
            });

        }
    </script>
</head>
<body>
<div class="container-fluid">
    <div class="row justify-content-md-center">
        <div class="col-md-auto">
            <div class="h1"> 게시판 - 수정</div>
        </div>
    </div>
    <form id="boardModifyForm" name="boardModifyForm" action="./api/modify.jsp" method="post" onsubmit="return boardModifyFormCheck();" enctype="multipart/form-data">
        <input type="hidden" id="boardNum" name="boardNum" value="<%= boardNum %>">
        <div class="card">
            <div class="card-body">
                <div class="mb-3 row">
                    <label for="categoryName" class="col-sm-2 col-form-label">카테고리</label>
                    <div class="col-sm-5">
                        <input type="text" readonly class="form-control-plaintext" id="categoryName"
                               value="<%= categoryName %>">
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardRegisterDate" class="col-sm-2 col-form-label">등록 일시</label>
                    <div class="col-sm-5">
                        <input type="text" readonly class="form-control-plaintext" id="boardRegisterDate"
                               value="<%= boardRegisterDate %>">
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardUpdateDate" class="col-sm-2 col-form-label">수정 일시</label>
                    <div class="col-sm-5">
                        <input type="text" readonly class="form-control-plaintext" id="boardUpdateDate"
                               value="<%= boardUpdateDate %>">
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardHits" class="col-sm-2 col-form-label">조회수</label>
                    <div class="col-sm-5">
                        <input type="number" readonly class="form-control-plaintext" id="boardHits"
                               value="<%= boardHits %>">
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardWriter" class="col-sm-2 col-form-label">작성자 * </label>
                    <div class="col-sm-5">
                        <input type="text" class="form-control" id="boardWriter" value="<%= boardWriter %>"
                               name="boardWriter" minlength="3"
                               maxlength="4" required>
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardPassword" class="col-sm-2 col-form-label">비밀번호 * </label>
                    <div class="col-sm-5">
                        <input type="password" class="form-control" id="boardPassword" name="boardPassword"
                               placeholder="비밀번호" minlength="4" maxlength="15" placeholder="비밀번호" required>
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardTitle" class="col-sm-2 col-form-label">제목 * </label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="boardTitle" value="<%= boardTittle %>"
                               name="boardTitle" minlength="4"
                               maxlength="99" required>
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardContent" class="col-sm-2 col-form-label">내용 * </label>
                    <div class="col-sm-10">
                <textarea class="form-control" id="boardContent" name="boardContent" rows="7" minlength="4"
                          maxlength="1999" required><%= boardContent %></textarea>
                    </div>
                </div>
                <div class="mb-3 row">
                    <label class="col-sm-2 col-form-label">파일첨부</label>
                    <div class="col-sm-10">
                        <div class="row">
                            <div class="col-sm-12">
                                <% if (boardFileSize == 3) { %>
                                <%
                                    for (BoardDTO boardFileDTO : boardFileList) {
                                %>
                                <div class="row">
                                    <div class="col-sm-6" style="margin-bottom: 10px;">
                                        <input type="hidden" id="boardNum" name="boardNum"
                                               value="<%=boardDTO.getBoardNum()%>">
                                        <input type="hidden" id="fileNum<%=boardFileDTO.getFileNum()%>" name="fileNum"
                                               value="<%=boardFileDTO.getFileNum()%>">
                                        <a href="../file/<%=boardFileDTO.getFileUuidName()%>"
                                           download=""><%=boardFileDTO.getFileOriginName()%>
                                        </a>
                                        <br/>
                                    </div>
                                    <div class="col-sm-6" style="margin-bottom: 10px;">
                                        <button class="btn btn-danger" type="button"
                                                onclick="fileStateModify('<%=boardFileDTO.getFileNum()%>')">삭제
                                        </button>
                                    </div>
                                </div>
                                <%
                                    }
                                %>
                                <% } else { %>
                                <%
                                    for (BoardDTO boardFileDTO : boardFileList) {
                                %>
                                <div class="row">
                                    <div class="col-sm-6" style="margin-bottom: 10px;">
                                        <input type="hidden" id="boardNum" name="boardNum"
                                               value="<%=boardDTO.getBoardNum()%>">
                                        <input type="hidden" id="fileNum<%=boardFileDTO.getFileNum()%>" name="fileNum"
                                               value="<%=boardFileDTO.getFileNum()%>">
                                        <a href="../file/<%=boardFileDTO.getFileUuidName()%>"
                                           download=""><%=boardFileDTO.getFileOriginName()%>
                                        </a>
                                        <br/>
                                    </div>
                                    <div class="col-sm-6" style="margin-bottom: 10px;">
                                        <button class="btn btn-danger" type="button"
                                                onclick="fileStateModify('<%=boardFileDTO.getFileNum()%>')">삭제
                                        </button>
                                    </div>
                                </div>
                                <%
                                    }
                                %>
                                <%
                                    for (int i = 0; i < 3 - boardFileSize; i++) {
                                %>
                                <div class="col-sm-6"></div>
                                <div class="col-sm-6" style="margin-bottom: 10px;">
                                    <input class="form-control" type="file" id="boardfile<%=i%>" name="boardfile<%=i%>">
                                </div>
                                <%
                                    }
                                %>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <br/>
        <br/>
        <div class="row justify-content-between">
            <div class="col-sm-2">
                <div class="d-grid gap-2">
                    <button class="btn btn-danger" type="button"
                            onclick="location.href='/board/view.jsp?boardNum=<%=boardNum %>'">취소
                    </button>
                </div>
            </div>
            <div class="col-sm-2">
                <div class="d-grid gap-2">
                    <input type="submit"  class="btn btn-success" value="저장">
<%--                    <button type="button">저장</button>--%>
                </div>
            </div>
        </div>
    </form>
</div>
</body>
</html>
