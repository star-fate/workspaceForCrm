package com.bjpower.crm.workbench.web.controller;

import com.bjpower.crm.settings.domain.User;
import com.bjpower.crm.settings.service.UserService;
import com.bjpower.crm.settings.service.impl.UserServiceImpl;
import com.bjpower.crm.utils.*;
import com.bjpower.crm.vo.PaginationVo;
import com.bjpower.crm.workbench.dao.TranHistoryDao;
import com.bjpower.crm.workbench.domain.*;
import com.bjpower.crm.workbench.service.ActivityService;
import com.bjpower.crm.workbench.service.ContactsService;
import com.bjpower.crm.workbench.service.CustomerService;
import com.bjpower.crm.workbench.service.TranService;
import com.bjpower.crm.workbench.service.impl.ActivityServiceImpl;
import com.bjpower.crm.workbench.service.impl.ContactsServiceImpl;
import com.bjpower.crm.workbench.service.impl.CustomerServiceImpl;
import com.bjpower.crm.workbench.service.impl.TranServiceImpl;
import com.mysql.cj.util.DnsSrv;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

public class TranController extends HttpServlet {


    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到交易控制器");
        String path = request.getServletPath();
        if ("/workbench/transaction/add.do".equals(path)) {
            add(request,response);
        }else if ("/workbench/transaction/getCustomerName.do".equals(path)) {
            getCustomerName(request,response);
        }else if ("/workbench/transaction/getActivityListByName.do".equals(path)) {
            getActivityListByName(request,response);
        }else if ("/workbench/transaction/getContactListByName.do".equals(path)) {
            getContactListByName(request,response);
        }else if ("/workbench/transaction/save.do".equals(path)) {
            save(request,response);
        }else if ("/workbench/transaction/pageList.do".equals(path)) {
            pageList(request,response);
        }else if ("/workbench/transaction/detail.do".equals(path)) {
            detail(request,response);
        }else if ("/workbench/transaction/showTranHistory.do".equals(path)) {
            showTranHistory(request,response);
        }else if ("/workbench/transaction/changeStage.do".equals(path)) {
            changeStage(request,response);
        }else if ("/workbench/transaction/myCharts.do".equals(path)) {
            myCharts(request,response);
        }


    }

    private void myCharts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到绘制eCharts图 返回数据阶段");

        TranService ts = (TranService) serviceFactory.getService(new TranServiceImpl());
        Map<String,Object> map = ts.myCharts();
        PrintJson.printJsonObj(response,map);
    }

    private void changeStage(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到交易状态修改操作");
        String id= request.getParameter("id");
        String money = request.getParameter("money");
        String stage = request.getParameter("stage");
        String expectedDate = request.getParameter("expectedDate");

        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();

        //交易历史新加一条数据 交易操作修改数据
        //因为其需要在控制器中拿到 session 中的 user
        Tran t = new Tran();
        t.setId(id);
        t.setMoney(money);
        t.setStage(stage);
        t.setExpectedDate(expectedDate);
        t.setEditBy(editBy);
        t.setEditTime(editTime);

        TranService ts = (TranService) serviceFactory.getService(new TranServiceImpl());
        boolean flag = ts.changeStage(t);
        //还需要可能性
        Map<String,String> pMap = (Map<String, String>) this.getServletContext().getAttribute("pMap");
        t.setPossibility(pMap.get(t.getStage()));
        Map<String,Object> map = new HashMap<>();
        map.put("success",flag);
        map.put("t",t);
        PrintJson.printJsonObj(response,map);

    }


    private void showTranHistory(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到交易历史查询操作");
        String id = request.getParameter("id");
        TranService ts = (TranService) serviceFactory.getService(new TranServiceImpl());
        List<TranHistory> thList = ts.showTranHistory(id);
        Map<String,String> pMap = (Map<String, String>) this.getServletContext().getAttribute("pMap");
        for (TranHistory th:thList){
            th.setPossibility(pMap.get(th.getStage()));
        }
        PrintJson.printJsonObj(response,thList);

    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //
        System.out.println("进入到交易详细信息页面操作中");
        String id = request.getParameter("id");
        //根据ID信息查询交易表 将数据保存在request域中
        //需要 转换的 owner customerId activityId contactsId
        TranService ts = (TranService) serviceFactory.getService(new TranServiceImpl());
        Tran tran = ts.detail(id);
        Map<String,String> pMap = (Map<String, String>) this.getServletContext().getAttribute("pMap");
        String possibility = pMap.get(tran.getStage());
        tran.setPossibility(possibility);
        request.setAttribute("tran",tran);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        //接收数据 处理页面信息
        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String customerName = request.getParameter("customerName");
        String contactsName = request.getParameter("contactsName");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");

        //skipCount
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (Integer.valueOf(pageNoStr)-1)*Integer.valueOf(pageSizeStr);
        //将数据封装为一个Map
        Map<String,Object> map = new HashMap<>();
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);
        map.put("owner",owner);
        map.put("name",name);
        map.put("customerName",customerName);
        map.put("contactsName",contactsName);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        //将传回的vo接收 返回到 页面
        TranService ts = (TranService) serviceFactory.getService(new TranServiceImpl());
        PaginationVo<Tran> tVo = ts.pageList(map);
        PrintJson.printJsonObj(response,tVo);

    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws IOException {
        //需要完成的需求
        /*
            如果有 客户 则使用 没有则新建
            添加交易
            添加交易历史
         */
        System.out.println("进入到交易添加操作中");
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");

        String customerName = request.getParameter("customerName");
        Tran t = new Tran();

        t.setId(id);
        t.setOwner(owner);
        t.setMoney(money);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setStage(stage);
        t.setType(type);
        t.setSource(source);
        t.setActivityId(activityId);
        t.setContactsId(contactsId);
        t.setCreateTime(createTime);
        t.setCreateBy(createBy);
        t.setDescription(description);
        t.setContactSummary(contactSummary);
        t.setNextContactTime(nextContactTime);
        TranService ts = (TranService) serviceFactory.getService(new TranServiceImpl());
        boolean flag = ts.save(t,customerName);
        if (flag){
            response.sendRedirect(request.getContextPath()+"/workbench/transaction/index.jsp");
        }


    }

    private void getContactListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到模糊查询联系人列表操作中");
        String cname = request.getParameter("cname");
        //根据所传的信息查询
        ContactsService contactsService = (ContactsService) serviceFactory.getService(new ContactsServiceImpl());
        List<Contacts> contactsList = contactsService.getContactListByName(cname);
        PrintJson.printJsonObj(response,contactsList);
    }





    private void getActivityListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到模糊查询市场活动列表操作中");
        String aname = request.getParameter("aname");
        //根据所传的信息查询
        ActivityService as = (ActivityService) serviceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList = as.getActivityListByName(aname);
        PrintJson.printJsonObj(response,aList);

    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("进入到模糊查询客户名称列表操作中");
        CustomerService customerService = (CustomerService) serviceFactory.getService(new CustomerServiceImpl());
        String customerName = request.getParameter("name");
        List<String> cList = customerService.getCustomerName(customerName);
        PrintJson.printJsonObj(response,cList);

    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到跳转到交易添加页操作中");
        UserService us = (UserService) serviceFactory.getService(new UserServiceImpl());
        List<User> uList = us.getUserList();
        request.setAttribute("uList",uList);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request,response);

    }
}
