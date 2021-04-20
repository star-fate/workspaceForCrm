package com.bjpower.crm.workbench.service.impl;

import com.bjpower.crm.settings.dao.UserDao;
import com.bjpower.crm.settings.domain.User;
import com.bjpower.crm.utils.DateTimeUtil;
import com.bjpower.crm.utils.SqlSessionUtil;
import com.bjpower.crm.utils.UUIDUtil;
import com.bjpower.crm.vo.PaginationVo;
import com.bjpower.crm.workbench.dao.*;
import com.bjpower.crm.workbench.domain.*;
import com.bjpower.crm.workbench.service.ClueService;
import com.bjpower.crm.workbench.service.TranService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranServiceImpl implements TranService {
    private TranDao tranDao = SqlSessionUtil.getSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSession().getMapper(TranHistoryDao.class);



}
