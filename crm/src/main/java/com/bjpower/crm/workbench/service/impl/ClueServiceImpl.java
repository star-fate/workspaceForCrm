package com.bjpower.crm.workbench.service.impl;

import com.bjpower.crm.utils.SqlSessionUtil;
import com.bjpower.crm.workbench.dao.ClueDao;
import com.bjpower.crm.workbench.service.ClueService;

public class ClueServiceImpl implements ClueService {
    private ClueDao clueDao = SqlSessionUtil.getSession().getMapper(ClueDao.class);

}
