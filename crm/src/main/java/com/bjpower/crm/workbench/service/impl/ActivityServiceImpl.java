package com.bjpower.crm.workbench.service.impl;

import com.bjpower.crm.workbench.dao.ActivityDao;
import com.bjpower.crm.workbench.dao.ActivityRemarkDao;
import com.bjpower.crm.workbench.domain.Activity;
import com.bjpower.crm.workbench.domain.ActivityRemark;
import com.bjpower.crm.workbench.service.ActivityService;
import com.bjpower.crm.settings.dao.UserDao;
import com.bjpower.crm.settings.domain.User;
import com.bjpower.crm.utils.SqlSessionUtil;
import com.bjpower.crm.vo.PaginationVo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService{
    private ActivityDao activityDao = SqlSessionUtil.getSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSession().getMapper(ActivityRemarkDao.class);
    private UserDao userDao = SqlSessionUtil.getSession().getMapper(UserDao.class);
    @Override
    public boolean save(Activity activity) {
            boolean flag = false;
            int count = activityDao.save(activity);
            System.out.println(count    );
            if ( count == 1){
                    flag = true;
            }
            return flag;
        }

    @Override
    public List<Activity> getActivityListByName(String aname) {
        List<Activity> aList = activityDao.getActivityListByName(aname);
        return aList;
    }

    @Override
    public List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map) {

        List<Activity> aList = activityDao.getActivityListByNameAndNotByClueId(map);

        return aList;
    }

    @Override
    public List<Activity> getActivityListByClueId(String id) {

        List<Activity> aList = activityDao.getActivityListByClueId(id);

        return aList;
    }

    @Override
    public PaginationVo<Activity> pageList(Map<String, Object> map) {
            //需要使用Dao层来获取结果
            int total = activityDao.getTotalByCondition(map);
            List<Activity> dataList =  activityDao.getActivityListByCondition(map);
            System.out.println(total);
            System.out.println(dataList);
            PaginationVo<Activity> vo = new PaginationVo<>();
            vo.setTotal(total);
            vo.setDataList(dataList);
            return vo;
        }

    @Override
    public boolean updateRemark(ActivityRemark ar) {
        boolean flag = false;
        int count = activityRemarkDao.updateRemark(ar);
        if (count == 1){
            flag = true;
        }
        return flag;
    }

    @Override
    public List<ActivityRemark> getRemarkListByAid(String aId) {
        List<ActivityRemark> arList = activityRemarkDao.getRemarkListByAid(aId);
        return arList;
    }

    @Override
    public Activity detail(String id) {
        Activity activity = activityDao.detail(id);
        return activity;
    }

    @Override
    public boolean update(Activity activity) {
        boolean flag = false;
        int count = activityDao.update(activity);
        if (count == 1){
            flag = true;
        }
        return flag;
    }

    @Override
    public Map<String, Object> getUserListAndActivity(String id) {
        Map<String,Object> map = new HashMap<>();
        List<User> uList = userDao.getUserList();
        Activity activity = activityDao.getActivityById(id);
        map.put("uList",uList);
        map.put("activity",activity);
        return map;
    }

    @Override
    public boolean deleteRemark(String id) {
        boolean flag = true;
        int count = activityRemarkDao.deleteRemark(id);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean saveRemark(ActivityRemark ar) {
        boolean flag = true;
        int count = activityRemarkDao.saveRemark(ar);
        if (count != 1){
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean delete(String[] ids) {
        boolean flag = true;
        //查询出所需要删除的备注的数量
        int count1 = activityRemarkDao.getCountByAids(ids);
        //删除备注，返回受到影响的条数
        int count2 = activityRemarkDao.deleteByAids(ids);
        //比较两者是否相同
        System.out.println(count1+"--------"+count2);
        if(count1 != count2){
            flag = false;
        }
        int count3 = activityDao.delete(ids);
        System.out.println(count3);
        if (count3 != ids.length){
            flag = false;
        }
        return flag;
    }
}
