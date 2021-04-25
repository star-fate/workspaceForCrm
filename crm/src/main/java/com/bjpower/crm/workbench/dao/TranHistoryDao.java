package com.bjpower.crm.workbench.dao;

import com.bjpower.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    int save(TranHistory tranHistory);

    List<TranHistory> showTranHistory(String id);

}
