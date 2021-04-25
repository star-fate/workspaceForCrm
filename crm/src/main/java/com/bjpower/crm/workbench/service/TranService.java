package com.bjpower.crm.workbench.service;

import com.bjpower.crm.vo.PaginationVo;
import com.bjpower.crm.workbench.domain.Tran;
import com.bjpower.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranService {
    boolean save(Tran t, String customerName);

    PaginationVo<Tran> pageList(Map<String, Object> map);

    Tran detail(String id);

    List<TranHistory> showTranHistory(String id);

    boolean changeStage(Tran t);

    Map<String, Object> myCharts();

}
