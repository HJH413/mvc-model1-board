<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>게시판 - 수정</title>
    <%

    %>
    <%@ include file="include/source.jsp" %>
</head>
<body>
<div class="container-fluid">
    <div class="row justify-content-md-center">
        <div class="col-md-auto">
            <div class="h1"> 게시판 - 수정 </div>
        </div>
    </div>
    <form>
        <div class="card">
            <div class="card-body">
                <div class="mb-3 row">
                    <label for="categoryName" class="col-sm-2 col-form-label">카테고리</label>
                    <div class="col-sm-5">
                        <input type="text" readonly class="form-control-plaintext" id="categoryName" value="email@example.com">
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardRegisterDate" class="col-sm-2 col-form-label">등록 일시</label>
                    <div class="col-sm-5">
                        <input type="text" readonly class="form-control-plaintext" id="boardRegisterDate" value="2022.10.17 22:09">
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardUpdateDate" class="col-sm-2 col-form-label">수정 일시</label>
                    <div class="col-sm-5">
                        <input type="text" readonly class="form-control-plaintext" id="boardUpdateDate" value="2022.10.17 22:09">
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardHits" class="col-sm-2 col-form-label">조회수</label>
                    <div class="col-sm-5">
                        <input type="number" readonly class="form-control-plaintext" id="boardHits" value="5">
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardWriter" class="col-sm-2 col-form-label">작성자 * </label>
                    <div class="col-sm-5">
                        <input type="text" class="form-control" id="boardWriter" name="boardWriter">
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardPassword" class="col-sm-2 col-form-label">비밀번호 * </label>
                    <div class="col-sm-5">
                        <input type="password" class="form-control" id="boardPassword" name="boardPassword">
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardTitle" class="col-sm-2 col-form-label">제목 * </label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="boardTitle" name="boardTitle">
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="boardContent" class="col-sm-2 col-form-label">내용 * </label>
                    <div class="col-sm-10">
                <textarea class="form-control" id="boardContent" name="boardContent" rows="7">
                </textarea>
                    </div>
                </div>
                <div class="mb-3 row">
                    <label class="col-sm-2 col-form-label">파일첨부</label>
                    <div class="col-sm-10">
                        <div class="row">
                            <div class="col-sm-12" style="margin-bottom: 10px;">
                                <input class="form-control" type="file" id="boardfile1">
                            </div>
                            <div class="col-sm-12" style="margin-bottom: 10px;">
                                <input class="form-control" type="file" id="boardfile2">
                            </div>
                            <div class="col-sm-12" style="margin-bottom: 10px;">
                                <input class="form-control" type="file" id="boardfile3">
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
                    <button class="btn btn-success" type="button">저장</button>
                </div>
            </div>
        </div>
    </form>
</div>
</body>
</html>
