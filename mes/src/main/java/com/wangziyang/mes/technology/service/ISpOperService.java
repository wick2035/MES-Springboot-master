package com.wangziyang.mes.technology.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.technology.entity.SpOper;

/**
 * 工序服务
 *
 * @author WangZiYang
 * @since 2020-03-14
 */
public interface ISpOperService extends IService<SpOper> {

    /** 生成下一个工序编号 GX000001 */
    String nextOperCode();
}
