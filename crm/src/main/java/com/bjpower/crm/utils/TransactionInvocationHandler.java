package com.bjpower.crm.utils;

import org.apache.ibatis.session.SqlSession;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

public class TransactionInvocationHandler  implements InvocationHandler {
    private Object target;

    public TransactionInvocationHandler(Object target) {
        this.target = target;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        SqlSession session = null;
        Object res = null;

        try {
            session = SqlSessionUtil.getSession();
            res = method.invoke(target,args);
            session.commit();

        } catch (Exception e) {
            session.rollback();
            e.printStackTrace();
            //将得到的异常继续说上抛
            throw e.getCause();
        } finally {
            SqlSessionUtil.myClose(session);
        }
        return res;
    }
    //返回类型为Object
    public Object getProxy(){
        return Proxy.newProxyInstance(
                target.getClass().getClassLoader(),
                target.getClass().getInterfaces(),
                this
        );
    }
}
