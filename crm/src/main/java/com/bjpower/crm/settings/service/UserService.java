package com.bjpower.crm.settings.service;

import com.bjpower.crm.exception.loginException;
import com.bjpower.crm.settings.domain.User;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws loginException;


    List<User> getUserList();
}
