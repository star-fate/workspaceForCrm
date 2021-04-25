package com.bjpower.crm.workbench.service.impl;

import com.bjpower.crm.utils.DateTimeUtil;
import com.bjpower.crm.utils.SqlSessionUtil;
import com.bjpower.crm.utils.UUIDUtil;
import com.bjpower.crm.vo.PaginationVo;
import com.bjpower.crm.workbench.dao.*;
import com.bjpower.crm.workbench.domain.*;
import com.bjpower.crm.workbench.service.TranService;

import javax.swing.plaf.basic.BasicScrollPaneUI;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @Override
    public PaginationVo<Tran> pageList(Map<String, Object> map) {
        //分析需要返回的数据  total  以及  tranList
        int total = tranDao.getTotalCondition(map);
        //根据Map中的信息查询
        List<Tran> tranList = tranDao.getListByCondition(map);

        PaginationVo<Tran> tVo = new PaginationVo<>();
        tVo.setTotal(total);
        tVo.setDataList(tranList);
        return tVo;
    }

    @Override
    public Tran detail(String id) {
        Tran t = tranDao.detail(id);
        return t;
    }

    @Override
    public List<TranHistory> showTranHistory(String id) {

        List<TranHistory> thList = tranHistoryDao.showTranHistory(id);

        return thList;
    }

    @Override
    public boolean changeStage(Tran t) {
        boolean flag = true;
        int count = tranDao.changeStage(t);
        if (count != 1){
            flag = false;
        }
        //添加交易历史
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setStage(t.getStage());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setCreateBy(t.getEditBy());
        th.setCreateTime(t.getEditTime());
        th.setTranId(t.getId());

        int count2 = tranHistoryDao.save(th);
        if (count2 != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public Map<String, Object> myCharts() {
        //返回统计的条数
        int total = tranDao.getTotal();
        //返回分组统计的数据
        List<Map<String,String>> dataList = tranDao.getGroupList();

        Map<String,Object> map = new HashMap<>();

        map.put("total",total);
        map.put("dataList",dataList);

        return map;
    }
}
