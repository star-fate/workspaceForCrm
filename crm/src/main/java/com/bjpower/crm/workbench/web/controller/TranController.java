package com.bjpower.crm.workbench.web.controller;

import com.bjpower.crm.settings.domain.User;
import com.bjpower.crm.settings.service.UserService;
import com.bjpower.crm.settings.service.impl.UserServiceImpl;
import com.bjpower.crm.utils.PrintJson;
import com.bjpower.crm.utils.SqlSessionUtil;
import com.bjpower.crm.utils.serviceFactory;
import com.bjpower.crm.workbench.domain.Activity;
import com.bjpower.crm.workbench.domain.Contacts;
import com.bjpower.crm.workbench.domain.Customer;
import com.bjpower.crm.workbench.service.ActivityService;
import com.bjpower.crm.workbench.service.ContactsService;
import com.bjpower.crm.workbench.service.CustomerService;
import com.bjpower.crm.workbench.service.impl.ActivityServiceImpl;
import com.bjpower.crm.workbench.service.impl.ContactsServiceImpl;
import com.bjpower.crm.workbench.service.impl.CustomerServiceImpl;

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
