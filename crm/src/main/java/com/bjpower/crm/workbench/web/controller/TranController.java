package com.bjpower.crm.workbench.web.controller;

import com.bjpower.crm.settings.domain.User;
import com.bjpower.crm.settings.service.UserService;
import com.bjpower.crm.settings.service.impl.UserServiceImpl;
import com.bjpower.crm.utils.*;
import com.bjpower.crm.workbench.domain.Activity;
import com.bjpower.crm.workbench.domain.Contacts;
import com.bjpower.crm.workbench.domain.Customer;
import com.bjpower.crm.workbench.domain.Tran;
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
import java.util.List;

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
        }


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
