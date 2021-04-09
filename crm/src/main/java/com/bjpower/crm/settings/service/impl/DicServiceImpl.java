package com.bjpower.crm.settings.service.impl;

import com.bjpower.crm.settings.dao.DicTypeDao;
import com.bjpower.crm.settings.dao.DicValueDao;
import com.bjpower.crm.settings.domain.DicType;
import com.bjpower.crm.settings.domain.DicValue;
import com.bjpower.crm.settings.service.DicService;
import com.bjpower.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DicServiceImpl implements DicService {
    private DicValueDao dicValueDao = SqlSessionUtil.getSession().getMapper(DicValueDao.class);
    private DicTypeDao dicTypeDao = SqlSessionUtil.getSession().getMapper(DicTypeDao.class);


    @Override
    public Map<String, List<DicValue>> getAll() {
        //获取DicType的值 List<DicType>，使其作为值查询value
        List<DicType> dtList =  dicTypeDao.getTypeList();
        Map<String, List<DicValue>> map = new HashMap<>();
        for (DicType dt:dtList){
            String code = dt.getCode();
            List<DicValue> dvList =  dicValueDao.getListByCode(code);
            map.put(code+"List",dvList);
        }
        return map;
    }
}
