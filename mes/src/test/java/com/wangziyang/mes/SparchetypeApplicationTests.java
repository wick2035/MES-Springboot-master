package com.wangziyang.mes;

import com.wangziyang.mes.system.dto.SysUserDTO;
import com.wangziyang.mes.system.service.ISysUserService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

@RunWith(SpringRunner.class)
@SpringBootTest
public class SparchetypeApplicationTests {

    @Autowired
    private ISysUserService sysUserService;

    @Test
    public void contextLoads() {
    }

    @Test
    public void adminUserCanBeLoadedForLogin() throws Exception {
        SysUserDTO user = sysUserService.getUserAndRoleAndMenuByUsername("admin");
        assertNotNull(user);
        assertEquals("admin", user.getUsername());
    }

}
