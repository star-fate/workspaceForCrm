package com.bjpower.crm.workbench.service.impl;

import com.bjpower.crm.settings.dao.UserDao;
import com.bjpower.crm.settings.domain.User;
import com.bjpower.crm.utils.SqlSessionUtil;
import com.bjpower.crm.vo.PaginationVo;
import com.bjpower.crm.workbench.dao.ClueActivityRelationDao;
import com.bjpower.crm.workbench.dao.ClueDao;
import com.bjpower.crm.workbench.domain.Clue;
import com.bjpower.crm.workbench.domain.ClueActivityRelation;
import com.bjpower.crm.workbench.service.ClueService;

import javax.management.ObjectName;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueServiceImpl implements ClueService {
    private ClueDao clueDao = SqlSessionUtil.getSession().getMapper(ClueDao.class);
    private UserDao userDao = SqlSessionUtil.getSession().getMapper(UserDao.class);
    private ClueActivityRelationDao clueActivityRelationDao = SqlSessionUtil.getSession().getMapper(ClueActivityRelationDao.class);
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
}
