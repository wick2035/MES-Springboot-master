package com.wangziyang.mes.llm.service.impl;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONArray;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.entity.SpProcessingUnit;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
import com.wangziyang.mes.basedata.service.ISpProcessingUnitService;
import com.wangziyang.mes.llm.config.DashScopeClient;
import com.wangziyang.mes.llm.service.ILlmBomGenService;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.service.ISpOperService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * AI 辅助 BOM 生成实现。
 *
 * 「AI智能建模」向导步骤①使用：除 BOM 子项外，同时生成
 * 每个子项的物料属性建议（类型/来源/提前期/安全库存）与工序序列建议。
 */
@Service
public class LlmBomGenServiceImpl implements ILlmBomGenService {

    private static final Logger log = LoggerFactory.getLogger(LlmBomGenServiceImpl.class);

    @Autowired
    private DashScopeClient client;

    @Autowired
    private ISpMaterileService materileService;

    @Autowired
    private ISpOperService operService;

    @Autowired
    private ISpProcessingUnitService unitService;

    @Override
    public JSONObject generateDraft(String productName, String productDesc, String structureHint, Integer bomLevel) {
        if (!client.isConfigured()) {
            throw new RuntimeException("未配置大模型 API Key，请设置环境变量 DASHSCOPE_API_KEY 后重启应用。");
        }
        int level = bomLevel == null ? 0 : bomLevel;

        JSONArray messages = new JSONArray();
        messages.add(new JSONObject().put("role", "system").put("content", systemPrompt()));
        messages.add(new JSONObject().put("role", "user").put("content",
                buildUserPrompt(productName, productDesc, structureHint, level)));

        JSONObject resp = client.chat(messages, null);
        String content = extractContent(resp);
        JSONObject draft = parseDraft(content);

        // 物料匹配：尽量映射到现有物料主数据
        JSONObject header = draft.getJSONObject("header");
        if (header == null) {
            header = new JSONObject();
            draft.put("header", header);
        }
        if (StrUtil.isBlank(header.getStr("materielDesc"))) {
            header.put("materielDesc", productName);
        }
        header.put("bomLevel", level);

        JSONArray items = draft.getJSONArray("items");
        if (items == null) {
            items = new JSONArray();
            draft.put("items", items);
        }
        int matchedCount = 0;
        for (Object o : items) {
            JSONObject item = (JSONObject) o;
            // 产品BOM(level=0)子项仅允许 PG/COMP，AI 给出 PART/FG 时纠偏为 COMP，避免保存必败
            if (level == 0) {
                String t = item.getStr("itemMatType");
                if (!"PG".equals(t) && !"COMP".equals(t)) {
                    item.put("itemMatType", "COMP");
                    item.put("typeAdjusted", true);
                }
            }
            SpMaterile m = matchMaterile(item.getStr("materielItemCode"), item.getStr("materielItemDesc"));
            if (m != null) {
                item.put("materielItemCode", m.getMateriel());
                item.put("materielItemDesc", m.getMaterielDesc());
                if (StrUtil.isBlank(item.getStr("itemUnit"))) {
                    item.put("itemUnit", m.getUnit());
                }
                if (level != 0 && StrUtil.isBlank(item.getStr("itemMatType"))) {
                    item.put("itemMatType", m.getMatType());
                }
                // 命中物料主数据时回填真实属性，供向导步骤②展示
                item.put("materielId", m.getId());
                item.put("matType", m.getMatType());
                item.put("matSource", m.getMatSource());
                item.put("leadTime", m.getLeadTime());
                item.put("safetyStock", m.getSafetyStock());
                item.put("matched", true);
                matchedCount++;
            } else {
                item.put("matched", false);
            }
        }

        // 工序序列建议：与现有工序主数据匹配
        JSONArray opers = draft.getJSONArray("opers");
        if (opers == null) {
            opers = new JSONArray();
        }
        int operMatchedCount = matchOpers(opers);

        JSONObject result = new JSONObject();
        result.put("header", header);
        result.put("items", items);
        result.put("matchedCount", matchedCount);
        result.put("totalItems", items.size());
        result.put("opers", opers);
        result.put("operMatchedCount", operMatchedCount);
        result.put("totalOpers", opers.size());
        return result;
    }

    /**
     * 工序匹配：按工序名称（oper_desc）精确匹配现有工序主数据，
     * 命中则回填工序ID/编码/加工单元信息。
     *
     * @return 匹配命中数量
     */
    @Override
    public int matchOpers(JSONArray opers) {
        int matched = 0;
        int seq = 1;
        for (Object o : opers) {
            JSONObject op = (JSONObject) o;
            if (op.getInt("sortNum") == null) {
                op.put("sortNum", seq);
            }
            seq++;
            String desc = StrUtil.trimToEmpty(op.getStr("operDesc"));
            op.put("operDesc", desc);
            SpOper exist = StrUtil.isBlank(desc) ? null : operService.getOne(new QueryWrapper<SpOper>()
                    .eq("oper_desc", desc).last("limit 1"), false);
            if (exist != null) {
                op.put("matched", true);
                op.put("operId", exist.getId());
                op.put("oper", exist.getOper());
                op.put("unitId", exist.getUnitId());
                op.put("operHours", exist.getOperHours());
                op.put("manuCycle", exist.getManuCycle());
                String unitName = "";
                if (StrUtil.isNotBlank(exist.getUnitId())) {
                    SpProcessingUnit u = unitService.getById(exist.getUnitId());
                    if (u != null) {
                        unitName = u.getUnitName();
                    }
                }
                op.put("unitName", unitName);
                matched++;
            } else {
                op.put("matched", false);
            }
        }
        return matched;
    }

    private SpMaterile matchMaterile(String code, String desc) {
        if (StrUtil.isNotBlank(code)) {
            SpMaterile byCode = materileService.getOne(new QueryWrapper<SpMaterile>()
                    .eq("materiel", code).ne("is_deleted", "1").last("limit 1"), false);
            if (byCode != null) {
                return byCode;
            }
        }
        if (StrUtil.isNotBlank(desc)) {
            return materileService.getOne(new QueryWrapper<SpMaterile>()
                    .eq("materiel_desc", desc).ne("is_deleted", "1").last("limit 1"), false);
        }
        return null;
    }

    private String systemPrompt() {
        return "你是资深制造工艺工程师，擅长根据产品拆解 BOM（物料清单）并规划加工工艺。"
                + "请严格只输出一个 JSON 对象，不要输出任何解释文字或 Markdown 代码块标记。"
                + "JSON 结构为：{\"header\":{\"materielDesc\":\"产品名称\",\"versionNumber\":\"1\"},"
                + "\"items\":[{\"materielItemDesc\":\"子项名称\",\"materielItemCode\":\"建议编码或留空\","
                + "\"itemNum\":数量,\"itemUnit\":\"单位\",\"operTyper\":\"所属工序名\",\"itemMatType\":\"PART或COMP或PG\","
                + "\"matType\":\"PART或COMP或PG\",\"matSource\":\"SELF或OUT\",\"leadTime\":提前期天数,\"safetyStock\":安全库存数量,"
                + "\"subParts\":[{\"name\":\"基础零件名称\",\"num\":数量,\"unit\":\"单位\"}]}],"
                + "\"opers\":[{\"operDesc\":\"工序名称\",\"sortNum\":顺序号,\"operHours\":工时小时,\"manuCycle\":制造周期小时,\"remark\":\"工序说明\","
                + "\"contentText\":\"工序操作步骤简述\",\"requireText\":\"工序质量要求\",\"precautionText\":\"安全与注意事项\",\"techDocDesc\":\"技术文档说明\"}]}。"
                + "字段约束："
                + "itemMatType/matType 取值：PART=零件、COMP=组件、PG=半成品；"
                + "matSource 取值：SELF=自制（需要加工装配的）、OUT=外购（标准件/采购件）；"
                + "leadTime 为正整数天数（至少1），safetyStock 为非负整数；数量 itemNum 为正数。"
                + "当 itemMatType 为 COMP 或 PG 时，必须给出 subParts：该组件/半成品的下层 BOM 子零件清单（3-6 个，"
                + "名称要具体到真实零件，如主板模块给出 PCB基板、主控芯片、内存颗粒、供电模块；"
                + "同一组件内子零件名称不得重复）；itemMatType 为 PART 时 subParts 给空数组。"
                + "opers 为该产品的加工/装配工序序列，按先后顺序给出 5-10 道，"
                + "operHours 和 manuCycle 均为正整数小时，且 manuCycle 大于等于 operHours；"
                + "每道工序的 contentText/requireText/precautionText/techDocDesc 各 30-60 字，"
                + "用于自动生成工艺内容编制，须结合该工序的实际作业写具体，不要空泛。";
    }

    private String buildUserPrompt(String productName, String productDesc, String structureHint, int level) {
        StringBuilder sb = new StringBuilder();
        sb.append("请为以下产品生成 BOM 子项清单和工艺工序序列：\n");
        sb.append("产品名称：").append(StrUtil.nullToEmpty(productName)).append("\n");
        if (StrUtil.isNotBlank(productDesc)) {
            sb.append("产品描述：").append(productDesc).append("\n");
        }
        if (StrUtil.isNotBlank(structureHint)) {
            sb.append("结构/工艺提示：").append(structureHint).append("\n");
        }
        sb.append("目标 BOM 层级：").append(level).append("（0=成品 1=半成品 2=组件）\n");
        if (level == 0) {
            sb.append("注意：产品BOM（层级0）的子项 itemMatType 只能取 PG 或 COMP，不允许 PART。\n");
        }
        sb.append("请列出 5-15 个主要子项，覆盖该产品的关键零部件，并给出完整的工序序列。");
        return sb.toString();
    }

    private String extractContent(JSONObject resp) {
        JSONArray choices = resp.getJSONArray("choices");
        if (choices == null || choices.isEmpty()) {
            throw new RuntimeException("大模型未返回有效内容");
        }
        JSONObject msg = choices.getJSONObject(0).getJSONObject("message");
        return msg == null ? "" : StrUtil.nullToEmpty(msg.getStr("content"));
    }

    private JSONObject parseDraft(String content) {
        String json = stripFence(content);
        try {
            return JSONUtil.parseObj(json);
        } catch (Exception e) {
            log.error("BOM 草稿 JSON 解析失败, 原始内容: {}", content);
            throw new RuntimeException("AI 返回内容无法解析为 BOM 草稿，请重试或调整描述");
        }
    }

    /** 去除可能的 ```json ... ``` 围栏，并截取首个 { 到末个 } */
    private String stripFence(String content) {
        String s = StrUtil.trimToEmpty(content);
        s = s.replaceAll("(?s)```json", "").replaceAll("(?s)```", "").trim();
        int start = s.indexOf('{');
        int end = s.lastIndexOf('}');
        if (start >= 0 && end > start) {
            return s.substring(start, end + 1);
        }
        return s;
    }
}
