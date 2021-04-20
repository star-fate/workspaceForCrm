package com.bjpower.crm.workbench.dao;

import com.bjpower.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getClueRemarkById(String cId);

    int delete(String id);
}
