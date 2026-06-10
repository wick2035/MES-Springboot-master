package com.wangziyang.mes.llm.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.llm.entity.SpLlmMessage;
import com.wangziyang.mes.llm.mapper.LlmMessageMapper;
import com.wangziyang.mes.llm.service.ILlmMessageService;
import org.springframework.stereotype.Service;

@Service
public class LlmMessageServiceImpl extends ServiceImpl<LlmMessageMapper, SpLlmMessage>
        implements ILlmMessageService {
}
