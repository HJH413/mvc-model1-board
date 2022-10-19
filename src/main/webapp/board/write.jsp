<%@ page import="com.board.dto.CategoryDTO" %>
<%@ page import="com.board.repository.BoardDAO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    BoardDAO boardDAO = new BoardDAO();
    List<CategoryDTO> categoryList = boardDAO.categoryList();

%>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>게시판 - 등록</title>

    <%@ include file="include/source.jsp" %>
    <script type="text/javascript">

        const boardFormCheck = () => {
            if (document.getElementById('categoryName').value === '0') {
                alert("카테고리를 선택하세요.");
                return false;
            }

            if (boardPasswordCheckFunction() === false) {
                return false;
            }
        }

        /**
         * 비밀번호 유효성 검증하는 함수
         * @returns {boolean}
         */
        const boardPasswordCheckFunction = () => {
            let boardPassword = document.getElementById('boardPassword').value;
            let boardPasswordCheck = document.getElementById('boardPasswordCheck').value;
            let boardPasswordCheckText = document.getElementById('boardPasswordCheckText');
            const check = /^(?=.*[a-zA-Z])((?=.*\d)|(?=.*\W)).{4,16}$/ //  영문자 특문
            if (boardPassword !== boardPasswordCheck) {
                boardPasswordCheckText.innerHTML = "<div style='color:red'>" + '비밀번호 확인' + "</div>"
                document.getElementById("boardSubmit").setAttribute("disabled", "")
                return false
            } else if (!(check.test(boardPassword))) {
                boardPasswordCheckText.innerHTML = "<div style='color:red'>" + '영문/숫자/특문 포함 및 4자리 이상 16자리 미만' + "</div>"
                document.getElementById("boardSubmit").setAttribute("disabled", "")
                return false
            } else {
                boardPasswordCheckText.innerHTML = "<div style='color:red'>" + '' + "</div>"
                document.getElementById("boardSubmit").removeAttribute("disabled")
                return true
            }
        }
    </script>
</head>
<body>
<div class="container-fluid">
    <div class="row justify-content-md-center">
        <div class="col-md-auto">
            <div class="h1"> 게시판 - 등록</div>
        </div>
    </div>
    <br/>
    <br/>
    <form id="boardSaveForm" name="boardSaveForm" action="./api/save.jsp" method="post" onsubmit="return boardFormCheck();" enctype="multipart/form-data">
        <div class="card">
            <div class="card-body">
                <div class="mb-3 row">
                    <label for="categoryName" class="col-sm-2 col-form-label">카테고리</label>
                    <div class="col-sm-5">
                        <select id="categoryName" name="categoryNum" class="form-select"
                                aria-label="Default select example" required>
                            <option value="0">==선택하세요==</option>
                            <%
                                for (CategoryDTO categoryDTO : categoryList) {
                            %>
                            <option value="<%=categoryDTO.getCategoryNum() %>"><%=categoryDTO.getCategoryName() %>
                            </option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardWriter" class="col-sm-2 col-form-label">작성자 * </label>
                    <div class="col-sm-2">
                        <input type="text" class="form-control" id="boardWriter" name="boardWriter" minlength="3"
                               maxlength="4" required>
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardPassword" class="col-sm-2 col-form-label">비밀번호 * </label>
                    <div class="col-sm-2">
                        <input type="password" class="form-control" id="boardPassword" name="boardPassword"
                               minlength="4" maxlength="15" placeholder="비밀번호" required>
                    </div>
                    <div class="col-sm-2">
                        <input type="password" class="form-control" id="boardPasswordCheck" name="boardPassword2"
                               minlength="4" maxlength="15" placeholder="비밀번호 확인" onblur="boardPasswordCheckFunction()"
                               required>
                    </div>
                    <div class="col-sm-6" id="boardPasswordCheckText">

                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardTitle" class="col-sm-2 col-form-label">제목 * </label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="boardTitle" name="boardTitle" minlength="4"
                               maxlength="99" required>
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardContent" class="col-sm-2 col-form-label">내용 * </label>
                    <div class="col-sm-10">
                        <textarea class="form-control" id="boardContent" name="boardContent" rows="7" minlength="4"
                                  maxlength="1999" required></textarea>
                    </div>
                </div>
                <div class="mb-3 row">
                    <label class="col-sm-2 col-form-label">파일첨부</label>
                    <div class="col-sm-10">
                        <div class="row">
                            <div class="col-sm-6" style="margin-bottom: 10px;">
                                <input class="form-control" type="file" id="boardfile1" name="boardfile1">
                            </div>
                            <div class="col-sm-6" style="margin-bottom: 10px;">

                            </div>
                            <div class="col-sm-6" style="margin-bottom: 10px;">
                                <input class="form-control" type="file" id="boardfile2" name="boardfile2">
                            </div>
                            <div class="col-sm-6" style="margin-bottom: 10px;">

                            </div>
                            <div class="col-sm-6" style="margin-bottom: 10px;">
                                <input class="form-control" type="file" id="boardfile3" name="boardfile3">
                            </div>
                            <div class="col-sm-6" style="margin-bottom: 10px;">

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
                    <button class="btn btn-danger" type="button" onclick="location.href='/'">취소</button>
                </div>
            </div>
            <div class="col-sm-2">
                <div class="d-grid gap-2">
                    <input type="submit" class="btn btn-success" id="boardSubmit" value="저장" disabled/>
                </div>
            </div>
        </div>
    </form>
</div>
</body>
</html>
