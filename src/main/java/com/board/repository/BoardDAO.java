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
     * 카테고리 목록을 출력하는 메소드
     * @return 카테고리 목록
     */
    public List<CategoryDTO> categoryList() throws Exception{

        PreparedStatement statement = null;
        ResultSet resultSet = null;

        List<CategoryDTO> categoryDTOList = new ArrayList<>();

        String sql = "SELECT category_num, category_name FROM study.category";

        try {
            Connection connection = DataBaseConnection.getDatabaseConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()){
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

    /**
     * 게시글 저장 함수
     * /api/save.jsp
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
            Connection connection = DataBaseConnection.getDatabaseConnection();
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
     * 연결 객체를 종료 시키는 메소드
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
     * @param password
     */
    public void passwordCheck(String password){

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
