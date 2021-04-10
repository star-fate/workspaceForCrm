package com.bjpower.crm.workbench.dao;

import com.bjpower.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int save(Clue c);

    List<Clue> getClueListByCondition(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);

    Clue getClueById(String cid);

    int update(Clue c);

    int deleteByCids(String[] ids);

    int getCountByCids(String[] ids);
}
