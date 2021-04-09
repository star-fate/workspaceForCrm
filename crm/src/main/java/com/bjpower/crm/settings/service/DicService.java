package com.bjpower.crm.settings.service;

import com.bjpower.crm.exception.loginException;
import com.bjpower.crm.settings.domain.DicValue;
import com.bjpower.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface DicService {

    Map<String, List<DicValue>> getAll();
}
