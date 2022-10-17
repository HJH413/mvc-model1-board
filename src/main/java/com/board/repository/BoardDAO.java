package com.board.repository;

import com.board.dto.CategoryDTO;
import com.board.util.DataBaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BoardDAO {



    /**
     * 카테고리 목록을 출력하는 메소드
     * @return 카테고리 목록
     */
    public List<CategoryDTO> categoryList() throws Exception{

        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        List<CategoryDTO> categoryDTOList = new ArrayList<>();

        String sql = "SELECT category_num, category_name FROM category";

        try {
            connection = DataBaseConnection.getDatabaseConnection();
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

}// end of class
