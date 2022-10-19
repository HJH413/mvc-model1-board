package com.board.repository;

import com.board.dto.BoardDTO;
import com.board.dto.CategoryDTO;
import com.board.util.DataBaseConnection;
import com.board.util.SHA256;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BoardDAO {

    /**
     * C 게시글 저장 함수
     * /api/save.jsp
     *
     * @param boardDTO
     * @return 작성된 게시글의 번호
     */
    public int boardWriter(BoardDTO boardDTO) {

        PreparedStatement statement = null;
        ResultSet resultSet = null;
        SHA256 sha256 = new SHA256();

        String sql = "INSERT INTO study.board(board_writer, board_password, board_title, board_content, board_uuid, category_num)\n" +
                "VALUES (?, ?, ?, ?, ?, ?)";
        String sql2 = "SELECT board_num FROM study.board WHERE board_uuid = ?";
        String boardUuid = boardDTO.getBoardUuid();
        int boardNum = 0;

        try {
            statement = connection.prepareStatement(sql);
            statement.setString(1, boardDTO.getBoardWriter());
            String cryptogramPassword = sha256.encrypt(boardDTO.getBoardPassword());
            statement.setString(2, cryptogramPassword);
            statement.setString(3, boardDTO.getBoardTittle());
            statement.setString(4, boardDTO.getBoardContent());
            statement.setString(5, boardUuid);
            statement.setInt(6, boardDTO.getCategoryNum());
            statement.executeUpdate();
            statement = connection.prepareStatement(sql2, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            statement.setString(1, boardUuid);
            resultSet = statement.executeQuery();
            resultSet.last();
            boardNum = resultSet.getInt("board_num");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            this.close(statement, resultSet);
        }

        return boardNum;
    }

    /**
     * R 게시글 상세보기
     * @param boardNum 게시글 번호
     * @return 게시글 번호에 해당하는 내용이 담긴 데이터 전달
     */
    public BoardDTO boardView(int boardNum) {

        PreparedStatement statement = null;
        ResultSet resultSet = null;
        BoardDTO boardDTO = new BoardDTO();

        String sql = "SELECT * FROM study.board " +
                "JOIN study.category c" +
                " ON board.category_num = c.category_num " +
                " WHERE  board_num = ? ";

        try {
            statement = connection.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            statement.setInt(1, boardNum);
            resultSet = statement.executeQuery();
            resultSet.last();
            boardDTO.setBoardNum(resultSet.getInt("board_num"));
            boardDTO.setBoardWriter(resultSet.getString("board_writer"));
            boardDTO.setBoardTittle(resultSet.getString("board_title"));
            boardDTO.setCategoryName(resultSet.getString("category_name"));
            boardDTO.setBoardContent(resultSet.getString("board_content"));
            boardDTO.setBoardHits(resultSet.getInt("board_hits"));
            boardDTO.setBoardRegisterDate(resultSet.getString("board_register_date"));
            boardDTO.setBoardUpdateDate(resultSet.getString("board_update_date"));
        } catch (Exception e) {

        } finally {
            close(statement, resultSet);
        }

        return boardDTO;
    }

    /**
     * U 게시글 내용 업데이트
     * @param boardDTO 저장할 내용을 담아 놓은 DTO
     */
    public void boardModify(BoardDTO boardDTO){

        PreparedStatement statement = null;
        SHA256 sha256 = new SHA256();

        String sql = "UPDATE study.board " +
                "SET board_writer = ?, " +
                "board_title = ?, " +
                "board_content = ?, " +
                "board_update_date = now() "+
                "WHERE board_num = ? " +
                "AND board_password = ?";

        try {
            statement = connection.prepareStatement(sql);
            statement.setString(1, boardDTO.getBoardWriter());
            statement.setString(2, boardDTO.getBoardTittle());
            statement.setString(3, boardDTO.getBoardContent());
            statement.setInt(4, boardDTO.getBoardNum());
            String cryptogramPassword = sha256.encrypt(boardDTO.getBoardPassword());
            statement.setString(5, cryptogramPassword);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(statement, null);
        }
    }

    /**
     * 게시글 삭제전 비밀번호 확인
     * @param boardNum 게시글 번호
     * @param boardPassword 게시글 비밀번호
     * @return 맞으면 1 실패하면 0
     */
    public int boardPasswordCheck(int boardNum, String boardPassword){

        PreparedStatement statement = null;
        ResultSet resultSet = null;
        SHA256 sha256 = new SHA256();

        String sql = "SELECT count(*) as count FROM study.board WHERE board_num = ? AND board_password = ?";
        int count = 0;

        try{
            statement = connection.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            statement.setInt(1, boardNum);
            String cryptogramPassword = sha256.encrypt(boardPassword);
            statement.setString(2, cryptogramPassword);
            resultSet = statement.executeQuery();
            resultSet.last();
            count = resultSet.getInt("count");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(statement, resultSet);
        }

        System.out.println("비밀번호 일치 여부 : " + count);
        return count;
    }

    /**
     * D 게시글 삭제 상태 변경
     * @param boardNum 게시글 번호
     */
    public void boardStateUpdate(int boardNum){

        PreparedStatement statement = null;

        String sql = "UPDATE study.board SET board_delete_state = 'Y' WHERE board_num = ?";

        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, boardNum);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(statement, null);
        }
    }

    /**
     * R 게시글 목록 불러오기
     * @return 게시글 목록 전달
     * todo 페이징
     */
    public List<BoardDTO> boardList() {

        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<BoardDTO> boardList = new ArrayList<>();

        String sql = "SELECT board_num, board_writer, board_title, " +
                            "board_hits, board_file_state, board_register_date, " +
                            "board_update_date, category_name " +
                     "FROM study.board " +
                     "JOIN study.category c " +
                     "ON c.category_num = board.category_num\n" +
                     "WHERE board_delete_state = 'N'\n" +
                     "ORDER BY board_register_date DESC, board_update_date DESC";
        String boardRegisterDate = "";
        String boardUpdateDate = "-";

        try {
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()){
                BoardDTO boardDTO = new BoardDTO();
                boardDTO.setBoardNum(resultSet.getInt("board_num"));
                boardDTO.setBoardHits(resultSet.getInt("board_hits"));
                boardDTO.setBoardWriter(resultSet.getString("board_writer"));
                boardDTO.setBoardTittle(resultSet.getString("board_title"));
                boardDTO.setBoardFileState(resultSet.getString("board_file_state"));
                boardDTO.setCategoryName(resultSet.getString("category_name"));
                boardRegisterDate = resultSet.getString("board_register_date");
                boardDTO.setBoardRegisterDate(boardRegisterDate.substring(0, resultSet.getString("board_register_date").length()-3));
                if(resultSet.getString("board_update_date") == null){
                    boardDTO.setBoardUpdateDate(boardUpdateDate);
                } else {
                    boardUpdateDate = resultSet.getString("board_update_date");
                    boardDTO.setBoardUpdateDate(boardUpdateDate.substring(0, boardUpdateDate.length()-3));
                }
                boardList.add(boardDTO);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(statement, resultSet);
        }

        return boardList;
    }

    //todo 검색기능 구현

    /**
     * C 파일 정보를 db에 적재
     * @param originFilaName 원래 파일명
     * @param fileName 업로드된 파일명
     * @param boardNum 게시글 번호
     * todo : 파일명 업로드시 UUID로 교체해야함
     */
    public void fileInfo(String originFilaName, String fileName, int boardNum) {

        PreparedStatement statement = null;

        String sql = "INSERT INTO study.file " +
                "(file_origin_name, file_uuid_name, board_num) " +
                "VALUES (?, ?, ?)";

        try {
            statement = connection.prepareStatement(sql);
            statement.setString(1, originFilaName);
            statement.setString(2, fileName);
            statement.setInt(3, boardNum);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            this.close(statement, null);
        }
    }

    /**
     * R 파일목록 가져오기 // 상세보기, 수정하기
     * @param boardNum 게시글 번호
     * @return 게시글의 파일목록 데이터 전달
     */
    public List<BoardDTO> boardFileList(int boardNum) {

        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<BoardDTO> boardFileList = new ArrayList<>();

        String sql = "SELECT file_origin_name, file_uuid_name, file_num" +
                " FROM study.file " +
                "WHERE board_num = ? AND file_delete_state = 'N' ";

        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, boardNum);
            resultSet = statement.executeQuery();
            while (resultSet.next()){
                BoardDTO boardDTO = new BoardDTO();
                boardDTO.setFileNum(resultSet.getInt("file_num"));
                boardDTO.setFileOriginName(resultSet.getString("file_origin_name"));
                boardDTO.setFileUuidName(resultSet.getString("file_uuid_name"));
                boardFileList.add(boardDTO);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            this.close(statement, resultSet);
        }

        return boardFileList;
    }

    /**
     * U 파일이 업로드 또는 삭제하는 게시글의 상태를 변경
     * @param boardNum 게시글 번호
     */
    public void boardFileStateUpdate(int boardNum) {

        PreparedStatement statement = null;

        String sql = "UPDATE study.board " +
                    "  SET board_file_state = CASE " +
                    "      WHEN (SELECT count(*) FROM study.file WHERE board_num = ? AND file_delete_state = 'N') = 0 THEN 'N' " +
                    "      ELSE 'Y' " +
                    "      END " +
                    "WHERE board_num = ? ";

        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, boardNum);
            statement.setInt(2, boardNum);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            this.close(statement, null);
        }
    }

    /**
     * 파일 삭제 여부 변경
     * @param fileNum
     */
    public void fileStateUpdate(int fileNum){

        PreparedStatement statement = null;

        String sql = "UPDATE study.file SET file_delete_state = 'Y' WHERE file_num = ?";

        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, fileNum);
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(statement, null);
        }
    }


    /**
     * U 조회수 증가
     * todo 새로고침 마다 조회수 증가 막기
     * @param boardNum 게시글 번호
     */
    public void boardHits(int boardNum){

        PreparedStatement statement = null;

        String sql = "UPDATE study.board SET board_hits = IFNULL(board_hits, 0) + 1 WHERE board_num = ?";

        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, boardNum);
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            this.close(statement, null);
        }
    }

    /**
     * C 댓글 작성 하기
     * @param boardDTO
     */
    public void boardCommentsWrite(BoardDTO boardDTO){

        PreparedStatement statement = null;
        SHA256 sha256 = new SHA256();

        String sql = "INSERT INTO study.comments (comments_writer, comments_password, comments_content, board_num) " +
                     "values (?, ?, ?, ?)";

        try {
            statement = connection.prepareStatement(sql);
            statement.setString(1,boardDTO.getCommentsWriter());
            String cryptogramPassword = sha256.encrypt(boardDTO.getCommentsPassword());
            statement.setString(2, cryptogramPassword);
            statement.setString(3,boardDTO.getCommentsContent());
            statement.setInt(4,boardDTO.getBoardNum());
            statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            this.close(statement, null);
        }
    }

    /**
     * R 댓글 리스트 출력
     * todo 댓글 목록 페이징 해야함
     * @param boardNum 게시글 번호
     * @return 댓글 리스트 전달
     */
    public List<BoardDTO> boardCommentsList(int boardNum){

        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<BoardDTO> boardCommentsList = new ArrayList<>();

        String sql = "SELECT comments_num, comments_writer, comments_content, comments_register_date " +
                     "FROM study.comments WHERE board_num = ? AND comments_delete_state = 'N' " +
                     "ORDER BY comments_register_date DESC";

        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1,boardNum);
            resultSet = statement.executeQuery();
            while (resultSet.next()){
                BoardDTO boardDTO = new BoardDTO();
                boardDTO.setCommentsNum(resultSet.getInt("comments_num"));
                boardDTO.setCommentsWriter(resultSet.getString("comments_writer"));
                boardDTO.setCommentsContent(resultSet.getString("comments_content"));
                boardDTO.setCommentsRegisterDate(resultSet.getString("comments_register_date").substring(0, resultSet.getString("comments_register_date").length()-3));
                boardCommentsList.add(boardDTO);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            this.close(statement, resultSet);
        }

        return boardCommentsList;
    }

    /**
     * U&D 댓글의 상태를 변경
     * @param commentsNum 댓글 번호
     * @param commentsPassword 댓글 비밀번호
     */
    public int commentsStateUpdate(int commentsNum, String commentsPassword) {

        PreparedStatement statement = null;
        SHA256 sha256 = new SHA256();
        int result = 0;

        String sql = "UPDATE study.comments " +
                "SET comments_delete_state = 'Y'" +
                "WHERE comments_num = ? " +
                "AND comments_password = ?";

        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, commentsNum);
            String cryptogramPassword = sha256.encrypt(commentsPassword);
            statement.setString(2, cryptogramPassword);
            result = statement.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(statement, null);
        }
        return result;
    }

    /**
     * 카테고리 목록을 출력하는 메소드
     * @return 카테고리 목록
     */
    public List<CategoryDTO> categoryList() {

        PreparedStatement statement = null;
        ResultSet resultSet = null;
        List<CategoryDTO> categoryDTOList = new ArrayList<>();

        String sql = "SELECT category_num, category_name FROM study.category";

        try {
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                CategoryDTO categoryDTO = new CategoryDTO();
                categoryDTO.setCategoryNum(resultSet.getInt("category_num"));
                categoryDTO.setCategoryName(resultSet.getString("category_name"));
                categoryDTOList.add(categoryDTO);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(statement, resultSet);
        }

        return categoryDTOList;
    }

    //연결 객체 가져오기
    Connection connection;
    {
        try {
            connection = DataBaseConnection.getDatabaseConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 연결 객체를 종료 시키는 메소드
     *
     * @param statement
     * @param resultSet
     */
    private void close(Statement statement, ResultSet resultSet) {
        if (resultSet != null) {
            try {
                resultSet.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (statement != null) {
            try {
                statement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

}// end of class
