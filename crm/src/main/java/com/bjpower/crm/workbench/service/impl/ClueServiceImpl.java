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
import com.fasterxml.jackson.databind.deser.std.FromStringDeserializer;
import org.apache.ibatis.ognl.ElementsAccessor;

import javax.management.ObjectName;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.spi.CalendarDataProvider;

public class ClueServiceImpl implements ClueService {
    //用户相关表
    private ClueDao clueDao = SqlSessionUtil.getSession().getMapper(ClueDao.class);
    //线索相关表
    private UserDao userDao = SqlSessionUtil.getSession().getMapper(UserDao.class);
    private ClueActivityRelationDao clueActivityRelationDao = SqlSessionUtil.getSession().getMapper(ClueActivityRelationDao.class);
    private ClueRemarkDao clueRemarkDao = SqlSessionUtil.getSession().getMapper(ClueRemarkDao.class);
    //顾客相关表
    private CustomerDao customerDao = SqlSessionUtil.getSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao = SqlSessionUtil.getSession().getMapper(CustomerRemarkDao.class);
    //联系人相关表
    private ContactsDao contactsDao = SqlSessionUtil.getSession().getMapper(ContactsDao.class);
    private ContactsRemarkDao contactsRemarkDao = SqlSessionUtil.getSession().getMapper(ContactsRemarkDao.class);
    private ContactsActivityRelationDao contactsActivityRelationDao = SqlSessionUtil.getSession().getMapper(ContactsActivityRelationDao.class);
    //交易相关表
    private TranDao tranDao = SqlSessionUtil.getSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSession().getMapper(TranHistoryDao.class);

    @Override
    public PaginationVo<Clue> pageList(Map<String, Object> map) {
        PaginationVo<Clue> pv = new PaginationVo<>();
        //根据map中的信息查询 返回 success 以及 cList
        int total = clueDao.getTotalByCondition(map);
        List<Clue> cList = clueDao.getClueListByCondition(map);
        pv.setTotal(total);
        pv.setDataList(cList);
        return pv;
    }

    @Override
    public boolean update(Clue c) {
        boolean flag = true;
        int count = clueDao.update(c);
        if (count != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndClue(String cid) {
        //返回数据需要 uList and  一条根据clueId查询的 clue
        List<User> uList = userDao.getUserList();
        Clue clue = clueDao.getClueById(cid);
        Map<String, Object> map = new HashMap<>();
        //封装为一个Map
        map.put("uList",uList);
        map.put("clue",clue);
        return map;
    }

    @Override
    public boolean save(Clue c) {
        //tbl_save 添加数据

        boolean flag = true;
        int count = clueDao.save(c);
        if (count != 1){
            flag = false;
        }

        return flag;
    }

    @Override
    public List<User> getUserList() {
        List<User> uList = userDao.getUserList();
        return uList;
    }

    @Override
    public Clue detail(String id) {
        //dao层取数据时注意，需要owner字段 ->连表操作
        Clue c = clueDao.detail(id);
        return c;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;
        int count1 = clueDao.getCountByCids(ids);
        int count2 = clueDao.deleteByCids(ids);

        if (count1 != count2){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean unbund(String id) {

        boolean flag = true;
        int count = clueActivityRelationDao.unbund(id);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean bund(List<ClueActivityRelation> cars) {
        boolean flag = true;
        //根据数据调用DAO层添加数据
        for (ClueActivityRelation car : cars){

        }
        /*
        NICE
         */
        int count = clueActivityRelationDao.bund(cars);

        //如果返回的影响条数 不是list数组的条数的话 则返回false
        if (count != cars.size()){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean convert(String cId, Tran t, String createBy) {
        //分析：转换的实现步骤？
        //做 调用 Dao层 之前的准备工作
        boolean flag = true;
        //(1) 获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）
        Clue c = clueDao.getClueById(cId);
        //(2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）
        Customer cur = customerDao.getByName(c.getCompany());
        if (cur == null){
            cur = new Customer();
            cur.setId(UUIDUtil.getUUID());
            cur.setOwner(c.getOwner());
            cur.setName(c.getCompany());
            cur.setWebsite(c.getWebsite());
            cur.setPhone(c.getPhone());
            cur.setCreateBy(createBy);
            cur.setCreateTime(DateTimeUtil.getSysTime());
            cur.setContactSummary(c.getContactSummary());
            cur.setNextContactTime(c.getNextContactTime());
            cur.setDescription(c.getDescription());
            cur.setAddress(c.getAddress());
            //添加客户
            int count1 = customerDao.save(cur);
            if (count1 != 1) {
                flag = false;
            }
        }
        //(3) 通过线索对象提取联系人信息，保存联系人
        Contacts contact = new Contacts();
        contact.setId(UUIDUtil.getUUID());
        contact.setOwner(c.getOwner());
        contact.setSource(c.getSource());
        //第二步获取或者创建的customerId
        contact.setCustomerId(cur.getId());
        contact.setFullname(c.getFullname());
        contact.setAppellation(c.getAppellation());
        contact.setEmail(c.getEmail());
        contact.setMphone(c.getMphone());
        contact.setJob(c.getJob());
        contact.setCreateBy(createBy);
        contact.setCreateTime(DateTimeUtil.getSysTime());
        contact.setDescription(c.getDescription());
        contact.setContactSummary(c.getContactSummary());
        contact.setNextContactTime(c.getNextContactTime());
        contact.setAddress(c.getAddress());
        int count2 = contactsDao.save(contact);
        if (count2 != 1) {
            flag = false;
        }

        //(4) 线索备注转换到客户备注以及联系人备注
        List<ClueRemark> clueRemarkList = clueRemarkDao.getClueRemarkById(cId);
        for (ClueRemark clueRemark:clueRemarkList){
            String noteContent = clueRemark.getNoteContent();

            //将线索的备注存入客户备注 以及 联系人备注

            //创建客户备注对象，添加客户备注
            CustomerRemark customerRemark = new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setCreateBy(createBy);
            customerRemark.setCreateTime(DateTimeUtil.getSysTime());
            customerRemark.setCustomerId(cur.getId());
            customerRemark.setNoteContent(noteContent);
            customerRemark.setEditFlag("0");

            int count3 = customerRemarkDao.save(customerRemark);
            if (count3 != 1) {
                flag = false;
            }

            //创建联系人备注对象，添加联系人备注
            ContactsRemark contactsRemark = new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setContactsId(contact.getId());
            contactsRemark.setCreateBy(createBy);
            contactsRemark.setCreateTime(DateTimeUtil.getSysTime());
            contactsRemark.setNoteContent(noteContent);
            contactsRemark.setEditFlag("0");

            int count4 = contactsRemarkDao.save(contactsRemark);
            if (count4 != 1) {
                flag = false;
            }


        }
        //(5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系
        List<ClueActivityRelation> carList = clueActivityRelationDao.getListByClueId(cId);
        for (ClueActivityRelation car:carList){
            ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(car.getActivityId());
            contactsActivityRelation.setContactsId(contact.getId());
            int count5 = contactsActivityRelationDao.save(contactsActivityRelation);
            if (count5 != 1){
                flag = false;
            }
        }
        //(6) 如果有创建交易需求，创建一条交易
        if (t != null){
            //创建一个交易
           /*
            已经装好的信息：
            t.setId(id);
            t.setName(name);
            t.setMoney(money);
            t.setStage(stage);
            t.setActivityId(activityId);
            t.setExpectedDate(expectedDate);
            t.setCreateBy(createBy);
            t.setCreateTime(createTime);
            */
            t.setOwner(c.getOwner());
            t.setSource(c.getSource());
            t.setNextContactTime(c.getNextContactTime());
            t.setDescription(c.getDescription());
            t.setCustomerId(cur.getId());
            t.setContactsId(contact.getId());
            t.setContactSummary(c.getContactSummary());
            int count6 = tranDao.save(t);
            if (count6 != 1) {
                flag = false;
            }
            /*id
            stage
            money
            expectedDate
            createTime
            createBy
            tranId*/
            //(7) 如果创建了交易，则创建一条该交易下的交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setStage(t.getStage());
            tranHistory.setMoney(t.getMoney());
            tranHistory.setExpectedDate(t.getExpectedDate());
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(DateTimeUtil.getSysTime());
            tranHistory.setTranId(t.getId());
            int count7 = tranHistoryDao.save(tranHistory);
            if (count7 != 1) {
                flag = false;
            }
        }



        //(8) 删除线索备注
       /* for (ClueRemark clueRemark:clueRemarkList){
            int count8 = clueRemarkDao.delete(clueRemark.getId());
            if (count8 != 1) {
                flag = false;
            }
        }*/

        //(9) 删除线索和市场活动的关系
       /* for (ClueActivityRelation car:carList){
            int count9 = clueActivityRelationDao.delete(car.getId());
            if (count9 != 1) {
                flag = false;
            }
        }*/


        //(10) 删除线索

       /* int count10 = clueDao.delete(cId);
        if (count10 != 1) {
            flag = false;
        }
        */
        return flag;
    }
}
