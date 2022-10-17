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
    <title>게시판</title>
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
            <div class="h1"> 게시판 - 목록</div>
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            <div class="row">
                <label for="board_register_date_start" class="form-label fw-bold">등록일</label>
                <div class="input-group">
                    <span class="input-group-text" id="span_board_register_date_start"><i class="fa-solid fa-calendar-days"> 시작일</i></span>
                    <input type="date" class="form-control input-group-sm" id="board_register_date_start" aria-describedby="span_board_register_date_start">
                    <span class="input-group-text" id="span_board_register_date_end"><i class="fa-solid fa-calendar-days"> 종료일</i></span>
                    <input type="date" class="form-control input-group-sm" id="board_register_date_end" aria-describedby="span_board_register_date_end">
                    <select name="category_num" class="form-select" aria-label="Default select example">
                        <option value="0">==선택하세요==</option>
                        <%
                            for (CategoryDTO categoryDTO : categoryList){
                        %>
                        <option value="<%=categoryDTO.getCategoryNum() %>"><%=categoryDTO.getCategoryName() %></option>
                        <%
                            }
                        %>
                    </select>

                </div>
                <div class="input-group">
                    <input type="text" class="form-control" placeholder="검색어를 입력해 주세요. (제목 + 작성자 + 내용)" aria-label="Recipient's username" aria-describedby="button-addon2">
                    <button class="btn btn-outline-dark btn-outline-secondary" type="button" id="button-addon2">검색</button>
                </div>
            </div>
        </div>
    </div>
    <br/>
    <br/>
    <div class="card">
        <div class="card-body">
            <div class="row">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">First</th>
                        <th scope="col">Last</th>
                        <th scope="col">Handle</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <th scope="row">1</th>
                        <td>Mark</td>
                        <td>Otto</td>
                        <td>@mdo</td>
                    </tr>
                    <tr>
                        <th scope="row">2</th>
                        <td>Jacob</td>
                        <td>Thornton</td>
                        <td>@fat</td>
                    </tr>
                    <tr>
                        <th scope="row">3</th>
                        <td colspan="2">Larry the Bird</td>
                        <td>@twitter</td>
                    </tr>
                    </tbody>
                </table>
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
            <div class="d-grid gap-2">
                <button class="btn btn-outline-dark" type="button">글 작성</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>
