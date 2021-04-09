package com.bjpower.crm.settings.service.impl;

import com.bjpower.crm.settings.dao.DicTypeDao;
import com.bjpower.crm.settings.dao.DicValueDao;
import com.bjpower.crm.settings.domain.DicType;
import com.bjpower.crm.settings.service.DicService;
import com.bjpower.crm.utils.SqlSessionUtil;

public class DicServiceImpl implements DicService {
    private DicValueDao dicValueDao = SqlSessionUtil.getSession().getMapper(DicValueDao.class);
    private DicTypeDao dicTypeDao = SqlSessionUtil.getSession().getMapper(DicTypeDao.class);


}
