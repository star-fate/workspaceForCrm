package com.bjpower.crm.workbench.service;

import com.bjpower.crm.workbench.domain.Tran;

public interface TranService {
    boolean save(Tran t, String customerName);

}
