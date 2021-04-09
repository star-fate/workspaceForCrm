package com.bjpower.crm.web.listener;

import com.bjpower.crm.settings.domain.DicValue;
import com.bjpower.crm.settings.service.DicService;
import com.bjpower.crm.settings.service.impl.DicServiceImpl;
import com.bjpower.crm.utils.serviceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class SysInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent event) {
        System.out.println("上下文/全局作用域被创建了");
        //在初始化时，获得数据字典，将其保存到 application 全局作用域 中
        //全局作用域对象保存在  event 中

        //获取全局作用域对象
        ServletContext application = event.getServletContext();
        /*
        获取数据——> 分析数据类型

        将其封装为 Map<String,List<DicValue>>
        String 为 DicType 的每一种 数据 code
         */
        //获取数据
        DicService ds = (DicService) serviceFactory.getService(new DicServiceImpl());
        Map<String, List<DicValue>> map = ds.getAll();
        Set<String> set = map.keySet();
        for (String key:set ){
            application.setAttribute(key,map.get(key));
        }
        System.out.println("上下文/全局作用域被创建成功了，数据添加成功");
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        System.out.println("上下文/全局作用域对象被销毁了");
    }
}
