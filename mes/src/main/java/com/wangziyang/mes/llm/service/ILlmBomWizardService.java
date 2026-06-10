package com.wangziyang.mes.llm.service;

import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import com.wangziyang.mes.system.entity.SysUser;

/**
 * AI 智能建模分步向导服务。
 *
 * 串联向导各步骤的落库动作：
 * 步骤② 未匹配物料一键入库（含 BOM 前置条件自动补齐）；
 * 步骤③ 缺失工序补建 + 工艺路线创建；
 * 步骤④ 工单创建 + 工序人员负载均衡分配。
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
     * 补建缺失工序并创建工艺路线（sp_flow + sp_flow_oper_relation）。
     *
     * @param productName 产品名称（用于流程描述）
     * @param opers       工序数组，operId 为空的行将新建工序（需 unitId）
     * @return {flowId, flow, process, createdOperCount, opers}
     */
    JSONObject createOpersAndFlow(String productName, JSONArray opers) throws Exception;

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
     * 创建工单（statue=1 待审批，走现有审批流）并保存工序人员分配。
     *
     * @param orderJson 工单信息：orderDescription/qty/materiel/materielDesc/flowId/planStartTime/planEndTime
     * @param assigns   分配数组，须覆盖工艺路线全部工序且 userId 非空
     * @param designer  设计人（当前登录用户）
     * @return {orderId, orderCode, assignCount}
     */
    JSONObject createOrderWithAssign(JSONObject orderJson, JSONArray assigns, SysUser designer);
}
