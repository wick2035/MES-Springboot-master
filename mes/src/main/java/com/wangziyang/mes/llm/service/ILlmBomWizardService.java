package com.wangziyang.mes.llm.service;

import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;

/**
 * AI 智能建模分步向导服务。
 *
 * 串联向导各步骤的落库动作：
 * 步骤② 未匹配物料一键入库（含 BOM 前置条件自动补齐）；
 * 步骤③ 缺失工序补建 + 工艺路线创建；
 * 步骤④ 生成生产订单草稿（进入生产计划中心后续确认/工单/派工/下发），并提供只读排人建议。
 */
public interface ILlmBomWizardService {

    /**
     * 批量创建未匹配物料，并自动补齐 BOM 保存的前置条件
     * （level=0：成品物料 + 零部件定义；level=1/2：表头零部件定义）。
     *
     * @param productName 产品名称
     * @param bomLevel    BOM 层级 0/1/2
     * @param materials   物料草稿数组（就地回填编码/ID）
     * @return {materials, headerMaterielCode, createdMaterialCount, createdComponentCount}
     */
    JSONObject batchCreateMaterials(String productName, Integer bomLevel, JSONArray materials);

    /**
     * 保存 BOM 全链并定版：
     * 对每个 PG/COMP 子项自动复用或创建下层 BOM（子件清单 subParts 作为 PART 物料与子项），
     * 子 BOM 逐个定版后，保存产品 BOM（子项关联 childBomId）并定版。
     *
     * @param header BOM 表头：bomCode/materielCode/materielDesc/versionNumber/bomLevel/factory
     * @param items  子项数组（含 subParts 子件清单）
     * @return {bomId, bomCode, childBomCount, createdMaterialCount, locked}
     */
    JSONObject saveBomFullChain(JSONObject header, JSONArray items);

    /**
     * 补建缺失工序并创建工艺路线（sp_flow + sp_flow_oper_relation）；
     * 当传入 bomId 时，额外完成：关联物料工艺路线、初始化工艺规划树（sp_process_route）、
     * 按 BOM 节点绑定工序、锁定规划，并按 opers 的内容字段预填工艺内容（状态置「编制中」）。
     *
     * @param productName 产品名称（用于流程描述）
     * @param opers       工序数组，operId 为空的行将新建工序（需 unitId），含 contentText 等工艺内容字段
     * @param bomId       步骤②保存定版的产品 BOM ID，可空（空则跳过工艺规划与内容预填）
     * @return {flowId, flow, process, createdOperCount, opers, routeCount, contentFilledCount}
     */
    JSONObject createOpersAndFlow(String productName, JSONArray opers, String bomId) throws Exception;

    /**
     * 按工艺路线预览人员分配（只读，不落库）。
     * 每道工序按「加工单元→班组→员工」链路选出当前未完成任务数最少的员工；
     * 同一次预览内已选中者负载 +1，避免全部压给同一人。
     *
     * @param flowId 工艺路线ID
     * @return 分配预览数组：operId/oper/operDesc/sortNum/unitId/unitName/teamId/teamName/userId/userName/currentLoad/warn
     */
    JSONArray previewAssign(String flowId);

    /**
     * 查询指定加工单元的可分配员工候选（含当前负载），供改人弹层使用。
     */
    JSONArray assignCandidates(String unitId);

    /**
     * 生成生产订单草稿（含单条产品明细），复用生产计划中心 saveOrder 校验BOM/排产并生成工序排产明细。
     * 后续的确认、生成工单、设备/员工派工、配套出库(MRP)、生产计划下发均在「生产计划中心」完成。
     *
     * @param orderJson 生产订单信息：sourceType(FORECAST/DEMAND)/qty/materiel/materielDesc/bomId/bomCode/
     *                  customerName(需求订单必填)/planStartDate(预测)/planDeliveryDate(需求)/targetCapacity/leadTimeDays/remark
     * @return {productionOrderId, orderNo, sourceType}
     */
    JSONObject createProductionOrder(JSONObject orderJson);
}
