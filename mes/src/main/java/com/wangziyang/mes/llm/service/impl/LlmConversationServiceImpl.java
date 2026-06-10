package com.wangziyang.mes.llm.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.llm.entity.SpLlmConversation;
import com.wangziyang.mes.llm.mapper.LlmConversationMapper;
import com.wangziyang.mes.llm.service.ILlmConversationService;
import org.springframework.stereotype.Service;

@Service
public class LlmConversationServiceImpl extends ServiceImpl<LlmConversationMapper, SpLlmConversation>
        implements ILlmConversationService {
}
