package com.bjpower.crm.workbench.service.impl;

import com.bjpower.crm.utils.SqlSessionUtil;
import com.bjpower.crm.workbench.dao.*;
import com.bjpower.crm.workbench.domain.Contacts;
import com.bjpower.crm.workbench.domain.ContactsRemark;
import com.bjpower.crm.workbench.service.ContactsService;
import com.bjpower.crm.workbench.service.CustomerService;

import java.util.List;

public class ContactsServiceImpl implements ContactsService {
    private TranDao tranDao = SqlSessionUtil.getSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSession().getMapper(TranHistoryDao.class);

    private CustomerDao customerDao = SqlSessionUtil.getSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao CustomerRemarkDao = SqlSessionUtil.getSession().getMapper(CustomerRemarkDao.class);

    private ContactsDao contactsDao = SqlSessionUtil.getSession().getMapper(ContactsDao.class);
    private ContactsRemarkDao contactsRemarkDao = SqlSessionUtil.getSession().getMapper(ContactsRemarkDao.class);

    @Override
    public List<Contacts> getContactListByName(String cname) {
        //根据传入的字符串 模糊查询 联系人列表
        List<Contacts> contactsList = contactsDao.getContactListByName(cname);

        return contactsList;
    }
}
