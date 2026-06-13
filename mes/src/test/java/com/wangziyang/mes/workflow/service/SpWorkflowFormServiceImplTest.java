package com.wangziyang.mes.workflow.service;

import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.workflow.entity.SpWorkflowTask;
import com.wangziyang.mes.workflow.service.impl.SpWorkflowFormServiceImpl;
import org.junit.Assert;
import org.junit.Test;

public class SpWorkflowFormServiceImplTest {

    @Test
    public void renderUrlShouldResolveWhitelistedWorkflowVariables() {
        SpWorkflowFormServiceImpl service = new SpWorkflowFormServiceImpl();
        SpWorkflowTask task = new SpWorkflowTask();
        task.setBusinessId("order-1001");
        task.setBusinessCode("WO20260611001");
        SysUser user = new SysUser();
        user.setName("planner");

        String url = service.renderUrl(
                "/order/release/add-or-update-ui?id=${task.procIns.bizKey}&code=${task.businessCode}&u=${form.currentUser.userName}",
                task,
                user);

        Assert.assertEquals("/order/release/add-or-update-ui?id=order-1001&code=WO20260611001&u=planner", url);
    }

    @Test
    public void renderTitleShouldFallbackToBusinessCodeWhenTemplateIsBlank() {
        SpWorkflowFormServiceImpl service = new SpWorkflowFormServiceImpl();
        SpWorkflowTask task = new SpWorkflowTask();
        task.setBusinessCode("WO20260611002");

        Assert.assertEquals("WO20260611002", service.renderTitle("", task, null));
    }
}
