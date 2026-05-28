package com.wangziyang.mes.technology.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.technology.entity.SpProcessRoute;
import com.wangziyang.mes.technology.vo.ProcessRouteNodeVO;

import java.util.List;

/**
 * 工艺流程服务接口
 */
public interface ISpProcessRouteService extends IService<SpProcessRoute> {

    /** 初始化指定BOM下所有节点的工艺记录（首次进入时调用，幂等） */
    int initRoutes(String bomId);

    /** 获取BOM下的工艺树 */
    ProcessRouteNodeVO getRouteTree(String bomId);

    /** 列出BOM下的所有工艺记录 */
    List<SpProcessRoute> listByBomId(String bomId);

    /** 绑定工序 */
    void bindOper(String routeId, String operId);

    /** 锁定整个BOM的工艺规划 */
    void lockAll(String bomId);

    /** 判断指定BOM是否已锁定（任一记录locked即视为已锁） */
    boolean isLocked(String bomId);
}
