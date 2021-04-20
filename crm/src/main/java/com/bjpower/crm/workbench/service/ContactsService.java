package com.bjpower.crm.workbench.service;

import com.bjpower.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {


    List<Contacts> getContactListByName(String cname);
}
