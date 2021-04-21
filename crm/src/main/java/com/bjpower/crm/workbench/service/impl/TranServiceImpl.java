package com.bjpower.crm.workbench.service.impl;

import com.bjpower.crm.utils.DateTimeUtil;
import com.bjpower.crm.utils.SqlSessionUtil;
import com.bjpower.crm.utils.UUIDUtil;
import com.bjpower.crm.workbench.dao.*;
import com.bjpower.crm.workbench.domain.*;
import com.bjpower.crm.workbench.service.TranService;
import org.apache.ibatis.reflection.wrapper.ObjectWrapper;

public class TranServiceImpl implements TranService {
    private TranDao tranDao = SqlSessionUtil.getSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSession().getMapper(TranHistoryDao.class);

    private CustomerDao customerDao = SqlSessionUtil.getSession().getMapper(CustomerDao.class);


    @Override
    public boolean save(Tran t, String customerName) {
        //根据客户名精确查找 如果有则返回 没有则 临时创建一个 客户
        boolean flag = true;
        Customer customer = customerDao.getByName(customerName);
        if (customer == null){
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(customerName);
            customer.setCreateTime(DateTimeUtil.getSysTime());
            customer.setCreateBy(t.getCreateBy());
            customer.setContactSummary(t.getContactSummary());
            customer.setNextContactTime(t.getNextContactTime());
            customer.setOwner(t.getOwner());
            int count = customerDao.save(customer);
            if (count != 1){
                flag = false;
            }
        }
        //添加交易
        t.setCustomerId(customer.getId());
        int count1 = tranDao.save(t);
        if (count1 != 1){
            flag = false;
        }
        //添加交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setMoney(t.getMoney());
        th.setTranId(t.getId());
        th.setCreateTime(t.getCreateTime());
        th.setCreateBy(t.getCreateBy());
        th.setExpectedDate(t.getExpectedDate());
        th.setStage(t.getStage());

        int count2 = tranHistoryDao.save(th);
        if (count2 != 1){
            flag = false;
        }
        return flag;
    }
}
