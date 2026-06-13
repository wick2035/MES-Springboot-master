package com.wangziyang.mes.workflow.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.workflow.entity.SpWorkflowEventLog;
import com.wangziyang.mes.workflow.mapper.SpWorkflowEventLogMapper;
import com.wangziyang.mes.workflow.service.ISpWorkflowEventLogService;
import org.springframework.stereotype.Service;

@Service
public class SpWorkflowEventLogServiceImpl extends ServiceImpl<SpWorkflowEventLogMapper, SpWorkflowEventLog>
        implements ISpWorkflowEventLogService {
}
