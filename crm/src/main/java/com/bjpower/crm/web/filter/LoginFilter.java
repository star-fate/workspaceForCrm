package com.bjpower.crm.web.filter;

import com.bjpower.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        //清楚需要放行的 页面+支持该页面的servlet服务
        String path = request.getServletPath();//ps:不包含项目名
        System.out.println(path);
        if ("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)){
            chain.doFilter(req,resp);
        }else {

            /*
            * 根据session对象  有无  user对象 来进行判断
            *
            * 需要一个前提  已经传入了 session
            *
            * 为了在用户登录阶段
            * 不出现一直重定向转发的问题 需要 上面的代码 放行 与登录（注册）有关的的服务或者页面
            * */
            //获取Session对象
            HttpSession session = request.getSession();
            //获取session中的 user对象
            User user = (User) session.getAttribute("user");
            //根据  会话作用域对象(session)中的 user对象 是否为空来进行判断
            if (user == null) {
                //使用重定向解决
                response.sendRedirect(request.getContextPath()+"/login.jsp");
            }else {
                chain.doFilter(req,resp);
            }

        }

    }
}
