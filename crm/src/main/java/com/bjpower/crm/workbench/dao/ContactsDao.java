package com.bjpower.crm.workbench.dao;

import com.bjpower.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {

    int save(Contacts contact);

    List<Contacts> getContactListByName(String cname);

}
