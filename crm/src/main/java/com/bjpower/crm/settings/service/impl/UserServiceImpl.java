package com.bjpower.crm.settings.service.impl;

import com.bjpower.crm.exception.loginException;
import com.bjpower.crm.settings.dao.UserDao;
import com.bjpower.crm.settings.domain.User;
import com.bjpower.crm.settings.service.UserService;
import com.bjpower.crm.utils.DateTimeUtil;
import com.bjpower.crm.utils.SqlSessionUtil;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceImpl implements UserService {
    private UserDao  userDao = SqlSessionUtil.getSession().getMapper(UserDao.class);


    @Override
    public User login(String loginAct, String loginPwd, String ip) throws loginException {
        Map<String,String> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);

        User user = userDao.login(map);
        if (user == null){
            //如果出现异常则该方法终止
            //统一异常处理
            throw new loginException("用户名或者密码错误");
        }
        //验证失效时间
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (currentTime.compareTo(expireTime) > 0){
            throw new loginException("该账号已失效");
        }
        //验证锁定状态
        String localState = user.getLockState();
        if ("0".equals(localState)){
            throw new loginException("该账号已被锁定");
        }

        //当前访问的ip地址已经传过来了
        //localhost:   0:0:0:0:0:0:0:1
        String allowIps = user.getAllowIps();

        if (!allowIps.contains(ip)){
            throw new loginException("ip地址受限");
        }
        return user;
    }

    @Override
    public List<User> getUserList() {
        List<User> uList = userDao.getUserList();
        return uList;
    }
}
