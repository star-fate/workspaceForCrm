package com.bjpower.crm.workbench.service;

import com.bjpower.crm.settings.domain.User;
import com.bjpower.crm.vo.PaginationVo;
import com.bjpower.crm.workbench.domain.Clue;
import com.bjpower.crm.workbench.domain.ClueActivityRelation;
import com.bjpower.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    List<User> getUserList();

    boolean save(Clue c);

    PaginationVo<Clue> pageList(Map<String, Object> map);

    Map<String, Object> getUserListAndClue(String cid);

    boolean update(Clue c);

    boolean delete(String[] ids);

    Clue detail(String id);

    boolean unbund(String id);

    boolean bund(List<ClueActivityRelation> cars);

    boolean convert(String cId, Tran t, String createBy);

}
