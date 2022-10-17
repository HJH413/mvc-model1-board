<%@ page import="com.board.repository.BoardDAO" %>
<%@ page import="com.board.dto.CategoryDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>게시판 - 보기</title>
    <%
        BoardDAO boardDAO = new BoardDAO();
        List<CategoryDTO> categoryList = boardDAO.categoryList();
    %>
    <%@ include file="include/source.jsp" %>
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
                    테스트
                </div>
                <div class="col-sm-7">
                </div>
                <div class="col-sm-2">
                    등록일 2022.10.17 22:32
                </div>
                <div class="col-sm-2">
                    수정일 2022.10.17 22:32
                </div>
                <br/>
                <div class="col-sm-12">
                    <div class="h2">[category] 제목출력</div>
                </div>
                <div class="col-sm-12">
                    <label for="boardContent" class="col-form-label"></label>
                    <textarea class="form-control" id="boardContent" name="boardContent" rows="7" readonly>
                        </textarea>
                </div>
            </div>
            <br/>
            <br/>
            <div class="col-sm-12">
                <div class="">첨부 파일 목록 출력 예정</div>
            </div>
        </div>
        <br/>
        <br/>
        <div class="card">
            <div class="card-body">
                <div><%--댓글 내용--%>
                    <div class="row justify-content-between">
                        <div class="col-sm-2">
                            <label for="commentsContent1" class="form-label">테스트 2022.10.17 22:32</label>
                        </div>
                        <div class="col-sm-2">
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <button class="btn btn-danger" type="button">삭제</button>
                            </div>
                        </div>
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" id="commentsContent1" class="form-control-plaintext" placeholder="댓글 내용"
                               readonly>
                    </div>
                    <hr/>
                    <div class="row justify-content-between">
                        <div class="col-sm-2">
                            <label for="commentsContent2" class="form-label">테스트 2022.10.17 22:32</label>
                        </div>
                        <div class="col-sm-2">
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <button class="btn btn-danger" type="button">삭제</button>
                            </div>
                        </div>
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" id="commentsContent2" class="form-control-plaintext" placeholder="댓글 내용"
                               readonly>
                    </div>
                    <hr/>
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
                    <div class="row">
                        <div class="col-sm-10">
                            <div class="form-floating">
                                    <textarea class="form-control" placeholder="Leave a comment here"
                                              id="floatingTextarea" rows="3"></textarea>
                                <label for="floatingTextarea">댓글을 입력해 주세요.</label>
                            </div>
                        </div>
                        <div class="col-sm-2">
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <button class="btn btn-info" type="button">등록</button>
                            </div>
                        </div>
                    </div>
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
