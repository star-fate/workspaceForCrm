package com.bjpower.crm.workbench.dao;

import com.bjpower.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {

    int unbund(String id);


    int bund(List<ClueActivityRelation> cars);
}
