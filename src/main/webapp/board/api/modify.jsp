<%@ page import="com.board.dto.BoardDTO" %>
<%@ page import="com.board.repository.BoardDAO" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.UUID" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    BoardDTO boardDTO = new BoardDTO();
    BoardDAO boardDAO = new BoardDAO();

    String uploadPath = "D:\\gdc-study\\mvc-model1-board\\src\\main\\webapp\\file";        // 업로드 경로
    int maxFileSize = 1024 * 1024 * 2000;    // 업로드 제한 용량 = 20MB
    String encoding = "utf-8";            // 인코딩

    MultipartRequest multi = new MultipartRequest(
            request,
            uploadPath,
            maxFileSize,
            encoding,
            new DefaultFileRenamePolicy()
    );

    int boardNum = Integer.parseInt(multi.getParameter("boardNum"));
    String boardWriter = multi.getParameter("boardWriter");
    String boardPassword = multi.getParameter("boardPassword");
    String boardTitle = multi.getParameter("boardTitle");
    String boardContent = multi.getParameter("boardContent");

    boardDTO.setBoardNum(boardNum);
    boardDTO.setBoardWriter(boardWriter);
    boardDTO.setBoardPassword(boardPassword);
    boardDTO.setBoardTittle(boardTitle);
    boardDTO.setBoardContent(boardContent);

    boardDAO.boardModify(boardDTO);

    //파일 업로드 (다중)
    String item="";
    String ofileName="";
    String fileName="";
    File file=null;

    Enumeration files = multi.getFileNames();
    while(files.hasMoreElements()){				//첨부파일 끝까지 계속 반복
        item=(String)files.nextElement();
        ofileName=multi.getOriginalFileName(item); 	 //원본 파일명
        fileName=multi.getFilesystemName(item);	  	//리네임
        if(fileName!=null){
            file=multi.getFile(item); 			 //파일담기
            if(file.exists()){  			//파일이 존재하는가
                boardDAO.fileInfo(ofileName, fileName, boardNum);
                boardDAO.boardFileStateUpdate(boardNum);
            }//if end
        }//if end
    }//while end

    response.sendRedirect("/board/view.jsp?boardNum="+boardNum);
%>