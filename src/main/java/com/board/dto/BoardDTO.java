package com.board.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BoardDTO {

    private int boardNum;
    private String boardWriter;
    private String boardPassword;
    private String boardTittle;
    private String boardContent;
    private String boardRegisterDate;
    private String boardUpdateDate;
    private int boardHits;
    private String boardFileState;
    private String boardDeleteState;
    private String boardUuid;

    private int categoryNum;
    private String categoryName;


}
