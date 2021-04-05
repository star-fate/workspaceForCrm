package com.bjpower.crm.utils;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;

public class SqlSessionUtil {
    private SqlSessionUtil() {
    }
    //创建静态私有的SqlSessionFactory
    private static SqlSessionFactory sqlSessionFactory;
    static {
        //资源文件所在地址
        String resource = "mybatis-config.xml";
        //输入流
        InputStream inputStream = null;
        try {
            inputStream = Resources.getResourceAsStream(resource);
        } catch (IOException e) {
            e.printStackTrace();
        }
        /*
         * SqlSessionFactoryBuilder:SqlSessionFactory的建造者；
         *   通过建造者对象调用建造方法为我们创建SqlSessionFactory对象
         *
         * SqlSessionFactory对象的唯一作用就是帮我们创建SqlSession对象
         *
         * */
        sqlSessionFactory =
                new SqlSessionFactoryBuilder().build(inputStream);
    }
    private  static ThreadLocal<SqlSession> t = new ThreadLocal<>();
    public static SqlSession getSession(){
        SqlSession session = t.get();
        if (session == null) {
            session = sqlSessionFactory.openSession();
            t.set(session);
        }
        return session;
    }
    public static void myClose(SqlSession session){
        if (session != null) {
            session.close();
            t.remove();
        }
    }
}
