package com.bjpower.crm.workbench.service.impl;

import com.bjpower.crm.utils.SqlSessionUtil;
import com.bjpower.crm.workbench.dao.CustomerDao;
import com.bjpower.crm.workbench.dao.CustomerRemarkDao;
import com.bjpower.crm.workbench.dao.TranDao;
import com.bjpower.crm.workbench.dao.TranHistoryDao;
import com.bjpower.crm.workbench.service.CustomerService;

import java.util.List;

public class CustomerServiceImpl implements CustomerService {
    private TranDao tranDao = SqlSessionUtil.getSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSession().getMapper(TranHistoryDao.class);

    private CustomerDao customerDao = SqlSessionUtil.getSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao CustomerRemarkDao = SqlSessionUtil.getSession().getMapper(CustomerRemarkDao.class);

    @Override
    public List<String> getCustomerName(String customerName) {
        List<String> cnList = customerDao.getCustomerName(customerName);
        return cnList;
    }
}
