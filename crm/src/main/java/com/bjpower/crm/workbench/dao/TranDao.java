package com.bjpower.crm.workbench.dao;

import com.bjpower.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {
    int save(Tran t);

    List<Tran> getListByCondition(Map<String, Object> map);

    int getTotalCondition(Map<String, Object> map);

    Tran detail(String id);

    int changeStage(Tran t);

    int getTotal();

    List<Map<String, String>> getGroupList();

}
