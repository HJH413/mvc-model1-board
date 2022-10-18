package com.board.repository;

import com.board.dto.BoardDTO;
import com.board.dto.CategoryDTO;
import com.board.util.DataBaseConnection;
import com.board.util.SHA256;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BoardDAO {

    Connection connection;
    {
        try {
            connection = DataBaseConnection.getDatabaseConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 게시글 저장 함수
     * /api/save.jsp
     *
     * @param boardDTO
     * @return 작성된 게시글의 번호
     */
    public int boardWriter(BoardDTO boardDTO) {

        SHA256 sha256 = new SHA256();

        PreparedStatement statement = null;
        ResultSet resultSet = null;

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
     * 파일 정보를 db에 적재
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
     * 파일이 업로드 또는 삭제 된다면 그 글의 상태를 변경
     * @param boardNum 게시글 번호
     */
    public void boardFileStateUpdate(int boardNum) {
        PreparedStatement statement = null;
        String sql = "UPDATE study.board " +
                    "  SET board_file_state = CASE " +
                    "      WHEN (SELECT count(*) FROM study.file WHERE board_num = ?) != 0 THEN 'Y' " +
                    "      ELSE 'N' " +
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
     * 게시글 상세보기
     * @param boardNum 게시글 번호
     * @return 게시글 번호에 해당하는 내용이 담긴 데이터 전달
     */
    public BoardDTO boardView(int boardNum) {

        BoardDTO boardDTO = new BoardDTO();

        PreparedStatement statement = null;
        ResultSet resultSet = null;

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
     * 파일목록 가져오기
     * @param boardNum 게시글 번호
     * @return 게시글의 파일목록 데이터 전달
     */
    public List<BoardDTO> boardFileList(int boardNum) {

        List<BoardDTO> boardFileList = new ArrayList<>();

        PreparedStatement statement = null;
        ResultSet resultSet = null;

        String sql = "SELECT file_origin_name, file_uuid_name, board_num" +
                     " FROM study.file " +
                     "WHERE board_num = ? AND file_delete_state = 'N' ";

        try {
            statement = connection.prepareStatement(sql);
            statement.setInt(1, boardNum);
            resultSet = statement.executeQuery();
            while (resultSet.next()){
                BoardDTO boardDTO = new BoardDTO();
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
     * 조회수 증가
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
     * 댓글 작성하기
     * @param boardDTO
     */
    public void boardCommentsWrite(BoardDTO boardDTO){

        SHA256 sha256 = new SHA256();

        PreparedStatement statement = null;

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


    public List<BoardDTO> boardCommentsList(int boardNum){

        List<BoardDTO> boardCommentsList = new ArrayList<>();

        PreparedStatement statement = null;
        ResultSet resultSet = null;

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

    public int commentsStateUpdate(int commentsNum, String commentsPassword) {

        SHA256 sha256 = new SHA256();
        PreparedStatement statement = null;

        String sql = "UPDATE study.comments " +
                     "SET comments_delete_state = 'Y'" +
                     "WHERE comments_num = ? " +
                     "AND comments_password = ?";

        int result = 0;

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

    /**
     * 복호화한 비밀번호 채크
     *
     * @param password
     */
    public void passwordCheck(String password) {

        SHA256 sha256 = new SHA256();

        PreparedStatement statement = null;
        ResultSet resultSet = null;

        String sql = "SELECT board_title FROM study.board WHERE board_password = ?";

        try {
            Connection connection = DataBaseConnection.getDatabaseConnection();
            //ResultSet에 사용할 수 있는 상수(TYPE_SCROLL_INSENSITIVE, CONCUR_READ_ONLY)
            statement = connection.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String cryptogramPassword = sha256.encrypt(password);
            statement.setString(1, cryptogramPassword);
            resultSet = statement.executeQuery();
            resultSet.last();
            System.out.println(resultSet.getString("board_title"));
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            this.close(statement, resultSet);
        }
    }

}// end of class
