package com.bjpower.crm.workbench.dao;

import com.bjpower.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {
    Customer getByName(String company);

    int save(Customer cur);

    List<String> getCustomerName(String customerName);
}
