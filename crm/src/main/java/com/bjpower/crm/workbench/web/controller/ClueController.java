package com.bjpower.crm.workbench.web.controller;

import com.bjpower.crm.settings.domain.User;
import com.bjpower.crm.settings.service.UserService;
import com.bjpower.crm.settings.service.impl.UserServiceImpl;
import com.bjpower.crm.utils.DateTimeUtil;
import com.bjpower.crm.utils.PrintJson;
import com.bjpower.crm.utils.UUIDUtil;
import com.bjpower.crm.utils.serviceFactory;
import com.bjpower.crm.vo.PaginationVo;
import com.bjpower.crm.workbench.domain.*;
import com.bjpower.crm.workbench.service.ActivityService;
import com.bjpower.crm.workbench.service.ClueService;
import com.bjpower.crm.workbench.service.impl.ActivityServiceImpl;
import com.bjpower.crm.workbench.service.impl.ClueServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.plaf.ActionMapUIResource;
import java.io.IOException;
import java.sql.ClientInfoStatus;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueController extends HttpServlet {


    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到线索控制器");
        String path = request.getServletPath();
        if ("/workbench/clue/getUserList.do".equals(path)) {
            getUserList(request,response);
        }else if ("/workbench/clue/save.do".equals(path)) {
            save(request,response);
        }else if ("/workbench/clue/pageList.do".equals(path)){
            pageList(request,response);
        }else if ("/workbench/clue/getUserListAndClue.do".equals(path)){
            getUserListAndClue(request,response);
        }else if ("/workbench/clue/update.do".equals(path)){
            update(request,response);
        }else if ("/workbench/clue/delete.do".equals(path)){
            delete(request,response);
        }else if ("/workbench/clue/detail.do".equals(path)){
            detail(request,response);
        }else if ("/workbench/clue/getActivityListByClueId.do".equals(path)){
            getActivityListByClueId(request,response);
        }else if ("/workbench/clue/unbund.do".equals(path)){
            unbund(request,response);
        }else if ("/workbench/clue/bund.do".equals(path)){
            bund(request,response);
        }else if ("/workbench/clue/getActivityListByNameAndNotByClueId.do".equals(path)){
            getActivityListByNameAndNotByClueId(request,response);
        }else if ("/workbench/clue/getActivityListByName.do".equals(path)){
            getActivityListByName(request,response);
        }else if ("/workbench/clue/convert.do".equals(path)){
            convert(request,response);
        }
    }
    //线索转换操作
    private void convert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String cId = request.getParameter("cId");
        //用于判断是否添加交易
        String flag = request.getParameter("flag");
        Tran t = null;

        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        //根据flag来判断是否  添加交易
        if ("a".equals(flag)){
            //获取其他的参数
            String expectedDate = request.getParameter("expectedDate");
            String name = request.getParameter("name");
            String money = request.getParameter("money");
            String stage = request.getParameter("stage");
            String activityId = request.getParameter("activityId");
            //另外需要获取创建时间 和 创建人
            String id = UUIDUtil.getUUID();
            String createTime = DateTimeUtil.getSysTime();
            //之后的业务也需要创建人的名字  但是呢 request 不能出现在 控制层之外的地方 为了遵守  MVC
            //String createBy = ((User)request.getSession().getAttribute("user")).getName();
            //将得到的参数封装为一个
            t = new Tran();
            t.setId(id);
            t.setName(name);
            t.setMoney(money);
            t.setStage(stage);
            t.setActivityId(activityId);
            t.setExpectedDate(expectedDate);
            t.setCreateBy(createBy);
            t.setCreateTime(createTime);
        }

        ClueService cs = (ClueService) serviceFactory.getService(new ClueServiceImpl());

        boolean flag1 = cs.convert(cId,t,createBy);
        if (flag1){
            //如果成功转移到
            response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");
        }

    }

    private void getActivityListByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据市场活动模糊查");
        String aname = request.getParameter("aname");
        ActivityService as = (ActivityService) serviceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList = as.getActivityListByName(aname);
        PrintJson.printJsonObj(response,aList);

    }

    private void bund(HttpServletRequest request, HttpServletResponse response) {
        //接收传入的参数
        String cid = request.getParameter("cid");
        String[] aids = request.getParameterValues("aid");


        //创建   UUID
        List<ClueActivityRelation> cars = new ArrayList<>();
        for (String aid:aids){
            String id = UUIDUtil.getUUID();
            ClueActivityRelation car = new ClueActivityRelation();
            car.setId(id);
            car.setClueId(cid);
            car.setActivityId(aid);
            cars.add(car);

        }
        //调用服务层
        ClueService cs = (ClueService) serviceFactory.getService(new ClueServiceImpl());
        boolean flag = cs.bund(cars);
        PrintJson.printJsonFlag(response,flag);


    }

    private void getActivityListByNameAndNotByClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询市场活动相关列表查询操作");
        String aname = request.getParameter("aname");
        String clueId = request.getParameter("clueId");

        ActivityService as = (ActivityService) serviceFactory.getService(new ActivityServiceImpl());
        Map<String,String> map = new HashMap<>();
        map.put("aname",aname);
        map.put("clueId",clueId);
        List<Activity> aList = as.getActivityListByNameAndNotByClueId(map);
        PrintJson.printJsonObj(response,aList);
    }

    private void unbund(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行解除关联操作");
        //获取参数
        String id = request.getParameter("id");
        //根据参数删除关联
        ClueService cs = (ClueService) serviceFactory.getService(new ClueServiceImpl());
        boolean flag =  cs.unbund(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getActivityListByClueId(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ActivityService as = (ActivityService) serviceFactory.getService(new ActivityServiceImpl());
        List<Activity> aList = as.getActivityListByClueId(id);
        PrintJson.printJsonObj(response,aList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        //根据ID查单条将结果写入request域
        ClueService cs = (ClueService) serviceFactory.getService(new ClueServiceImpl());
        Clue c = cs.detail(id);
        request.setAttribute("clue",c);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response){
        System.out.println("进入到删除线索操作中");
        String[] ids = request.getParameterValues("id");
        ClueService cs = (ClueService) serviceFactory.getService(new ClueServiceImpl());
        boolean flag = cs.delete(ids);
        PrintJson.printJsonFlag(response,flag);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改线索操作中");
        ClueService cs = (ClueService) serviceFactory.getService(new ClueServiceImpl());
        String id = request.getParameter("id");
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String owner = request.getParameter("owner");
        String company = request.getParameter("company");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");

        Clue c = new Clue();
        c.setId(id);
        c.setFullname(fullname);
        c.setAppellation(appellation);
        c.setOwner(owner);
        c.setCompany(company);
        c.setJob(job);
        c.setEmail(email);
        c.setPhone(phone);
        c.setWebsite(website);
        c.setMphone(mphone);
        c.setState(state);
        c.setSource(source);
        c.setEditBy(editBy);
        c.setEditTime(editTime);
        c.setDescription(description);
        c.setContactSummary(contactSummary);
        c.setNextContactTime(nextContactTime);
        c.setAddress(address);
        boolean flag = cs.update(c);
        PrintJson.printJsonFlag(response,flag);

    }

    private void getUserListAndClue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到获取用户表、clue操作");
        String cid = request.getParameter("clueId");
        ClueService cs = (ClueService) serviceFactory.getService(new ClueServiceImpl());
        Map<String,Object> map = cs.getUserListAndClue(cid);
        PrintJson.printJsonObj(response,map);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到根据条件clueList页面查看操作");
        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        String fullname = request.getParameter("fullname");
        String owner = request.getParameter("owner");
        String phone = request.getParameter("phone");
        String mphone = request.getParameter("mphone");
        String state  = request.getParameter("state ");
        String source = request.getParameter("source");
        String company = request.getParameter("company");
        //计算查询的数据条数
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (Integer.valueOf(pageNoStr) - 1)*pageSize;

        //以上数据存入一个 map 中
        Map<String,Object> map = new HashMap<>();
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        map.put("fullname",fullname);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("state",state);
        map.put("source",source);
        map.put("company",company);
        ClueService cs = (ClueService) serviceFactory.getService(new ClueServiceImpl());
        //返回一个  vo

        PaginationVo<Clue> pv = cs.pageList(map);
        PrintJson.printJsonObj(response,pv);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到线索保存操作");
        ClueService cs = (ClueService) serviceFactory.getService(new ClueServiceImpl());
        String id = UUIDUtil.getUUID();
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String owner = request.getParameter("owner");
        String company = request.getParameter("company");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String createTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");

        Clue c = new Clue();
        c.setId(id);
        c.setFullname(fullname);
        c.setAppellation(appellation);
        c.setOwner(owner);
        c.setCompany(company);
        c.setJob(job);
        c.setEmail(email);
        c.setPhone(phone);
        c.setWebsite(website);
        c.setMphone(mphone);
        c.setState(state);
        c.setSource(source);
        c.setCreateBy(createBy);
        c.setCreateTime(createTime);
        c.setDescription(description);
        c.setContactSummary(contactSummary);
        c.setNextContactTime(nextContactTime);
        c.setAddress(address);
        boolean flag = cs.save(c);
        PrintJson.printJsonFlag(response,flag);

    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到获取所有者列表操作");
        ClueService cs = (ClueService) serviceFactory.getService(new ClueServiceImpl());
        List<User> uList = cs.getUserList();
        PrintJson.printJsonObj(response,uList);

    }
}
