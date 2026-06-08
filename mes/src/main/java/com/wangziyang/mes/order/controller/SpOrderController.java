package com.wangziyang.mes.order.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.request.SpOrderReq;
import com.wangziyang.mes.order.service.ISpOrderService;
import com.wangziyang.mes.system.dto.SysRoleDTO;
import com.wangziyang.mes.system.dto.SysUserDTO;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.technology.entity.SpFlow;
import com.wangziyang.mes.technology.service.ISpFlowService;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * Production order release controller.
 */
@Controller
@RequestMapping("/order/release")
public class SpOrderController extends BaseController {

    private static final int STATUE_CREATED_PENDING_APPROVAL = 1;

    private static final int STATUE_APPROVED = 2;

    private static final String ROLE_CODE_ADMIN = "admin";

    private static final String ROLE_CODE_SUPER_ADMIN = "888888";

    private static final String ROLE_CODE_WAREHOUSE_MANAGER = "warehouseManagerRole";

    @Autowired
    private ISpOrderService orderService;

    @Autowired
    private ISpFlowService flowService;

    @ApiOperation("Production order release page")
    @GetMapping("/list-ui")
    public String listUI(Model model) {
        model.addAttribute("canApprove", canApproveOrder());
        return "/order/production/list";
    }

    @ApiOperation("Production order add/update page")
    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpOrder record) {
        SpOrder result;
        if (StringUtils.isNotEmpty(record.getId())) {
            result = orderService.getById(record.getId());
        } else {
            result = new SpOrder();
            result.setOrderCode(nextOrderCode());
            result.setOrderType("P");
            result.setStatue(STATUE_CREATED_PENDING_APPROVAL);
            fillDesigner(result, currentUser());
        }
        QueryWrapper<SpFlow> flowQw = new QueryWrapper<>();
        flowQw.orderByAsc("flow");
        model.addAttribute("result", result);
        model.addAttribute("flows", flowService.list(flowQw));
        return "/order/production/addOrUpdate";
    }

    @ApiOperation("Production order page query")
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpOrderReq req) {
        QueryWrapper<SpOrder> queryWrapper = buildQuery(req);
        queryWrapper.orderByDesc("update_time");
        IPage<SpOrder> result = orderService.page(req, queryWrapper);
        return Result.success(result);
    }

    @ApiOperation("Production order add/update")
    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpOrder record) {
        SpOrder db = null;
        if (record != null && StringUtils.isNotEmpty(record.getId())) {
            db = orderService.getById(record.getId());
            if (db == null) {
                return Result.failure("工单不存在");
            }
            if (db.getStatue() != null && db.getStatue() == STATUE_APPROVED) {
                return Result.failure("已审批工单不能编辑");
            }
        }
        Result validateResult = validate(record);
        if (validateResult != null) {
            return validateResult;
        }
        if (StringUtils.isEmpty(record.getId())) {
            fillDesigner(record, currentUser());
            record.setStatue(STATUE_CREATED_PENDING_APPROVAL);
            record.setApproveUserId(null);
            record.setApproveUsername(null);
            record.setApproveTime(null);
        } else {
            record.setDesignerId(db.getDesignerId());
            record.setDesignerName(db.getDesignerName());
            record.setStatue(db.getStatue());
            record.setApproveUserId(db.getApproveUserId());
            record.setApproveUsername(db.getApproveUsername());
            record.setApproveTime(db.getApproveTime());
        }
        orderService.saveOrUpdate(record);
        return Result.success();
    }

    @ApiOperation("Approve production order")
    @PostMapping("/approve")
    @ResponseBody
    public Result approve(SpOrder req) {
        if (!canApproveOrder()) {
            return Result.failure("当前用户没有工单审批权限");
        }
        if (req == null || StringUtils.isEmpty(req.getId())) {
            return Result.failure("请选择要审批的工单");
        }
        SpOrder order = orderService.getById(req.getId());
        if (order == null) {
            return Result.failure("工单不存在");
        }
        if (order.getStatue() == null || order.getStatue() != STATUE_CREATED_PENDING_APPROVAL) {
            return Result.failure("只有待审批工单可以审批通过");
        }

        SysUser user = currentUser();
        SpOrder update = new SpOrder();
        update.setId(order.getId());
        update.setStatue(STATUE_APPROVED);
        update.setApproveUserId(user == null ? null : user.getId());
        update.setApproveUsername(displayUsername(user));
        update.setApproveTime(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        orderService.updateById(update);
        return Result.success();
    }

    @ApiOperation("Delete production order")
    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpOrder req) {
        if (StringUtils.isEmpty(req.getId())) {
            return Result.failure("请选择要删除的工单");
        }
        orderService.removeById(req.getId());
        return Result.success();
    }

    @ApiOperation("Production order Gantt data")
    @ResponseBody
    @RequestMapping(value = "/gantt/list", method = RequestMethod.POST, produces = "application/json")
    public Result getListGantt(SpOrderReq req) {
        QueryWrapper<SpOrder> queryWrapper = buildQuery(req);
        queryWrapper.orderByAsc("plan_start_time");
        List<Map<String, Object>> result = new ArrayList<>();
        for (SpOrder order : orderService.list(queryWrapper)) {
            Date start = parsePlanTime(order.getPlanStartTime());
            Date end = parsePlanTime(order.getPlanEndTime());
            if (start == null || end == null || end.before(start)) {
                continue;
            }

            Map<String, Object> row = new HashMap<>(8);
            row.put("id", order.getId());
            row.put("name", StringUtils.defaultIfBlank(order.getMateriel(), order.getOrderCode()));
            row.put("desc", StringUtils.defaultString(order.getOrderDescription()));
            row.put("cssClass", cssClass(order.getStatue()));

            Map<String, Object> value = new HashMap<>(8);
            value.put("from", "/Date(" + start.getTime() + ")/");
            value.put("to", "/Date(" + end.getTime() + ")/");
            value.put("label", StringUtils.defaultIfBlank(order.getOrderCode(), "WO"));
            value.put("desc", "数量: " + (order.getQty() == null ? 0 : order.getQty()) + " / " + statueName(order.getStatue()));
            value.put("customClass", customClass(order.getStatue()));
            Map<String, Object> dataObj = new HashMap<>(4);
            dataObj.put("id", order.getId());
            dataObj.put("statue", order.getStatue());
            value.put("dataObj", dataObj);

            row.put("values", Collections.singletonList(value));
            result.add(row);
        }
        return Result.success(result);
    }

    private QueryWrapper<SpOrder> buildQuery(SpOrderReq req) {
        QueryWrapper<SpOrder> queryWrapper = new QueryWrapper<>();
        if (req == null) {
            return queryWrapper;
        }
        if (StringUtils.isNotEmpty(req.getOrderCodeLike())) {
            queryWrapper.like("order_code", req.getOrderCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getOrderDescriptionLike())) {
            queryWrapper.like("order_description", req.getOrderDescriptionLike());
        }
        if (StringUtils.isNotEmpty(req.getMaterielLike())) {
            queryWrapper.like("materiel", req.getMaterielLike());
        }
        if (StringUtils.isNotEmpty(req.getMaterielDescLike())) {
            queryWrapper.like("materiel_desc", req.getMaterielDescLike());
        }
        if (req.getStatue() != null) {
            queryWrapper.eq("statue", req.getStatue());
        }
        return queryWrapper;
    }

    private Result validate(SpOrder record) {
        if (record == null) {
            return Result.failure("工单信息不能为空");
        }
        record.setOrderCode(StringUtils.trimToEmpty(record.getOrderCode()));
        record.setOrderDescription(StringUtils.trimToEmpty(record.getOrderDescription()));
        record.setMateriel(StringUtils.trimToEmpty(record.getMateriel()));
        record.setMaterielDesc(StringUtils.trimToEmpty(record.getMaterielDesc()));
        record.setFlowId(StringUtils.trimToEmpty(record.getFlowId()));
        record.setOrderType(StringUtils.defaultIfBlank(record.getOrderType(), "P"));
        if (record.getStatue() == null) {
            record.setStatue(STATUE_CREATED_PENDING_APPROVAL);
        }

        if (StringUtils.isEmpty(record.getOrderCode())) {
            return Result.failure("请填写工单编号");
        }
        if (record.getQty() == null || record.getQty() <= 0) {
            return Result.failure("工单数量必须大于 0");
        }
        if (StringUtils.isEmpty(record.getMateriel()) || StringUtils.isEmpty(record.getMaterielDesc())) {
            return Result.failure("请选择工单物料");
        }
        if (StringUtils.isEmpty(record.getFlowId()) || flowService.getById(record.getFlowId()) == null) {
            return Result.failure("请选择有效的工艺路线");
        }

        Date start = parsePlanTime(record.getPlanStartTime());
        Date end = parsePlanTime(record.getPlanEndTime());
        if (start == null || end == null) {
            return Result.failure("请填写有效的计划开始和结束时间");
        }
        if (end.before(start)) {
            return Result.failure("计划结束时间不能早于计划开始时间");
        }

        QueryWrapper<SpOrder> duplicateQw = new QueryWrapper<>();
        duplicateQw.eq("order_code", record.getOrderCode());
        if (StringUtils.isNotEmpty(record.getId())) {
            duplicateQw.ne("id", record.getId());
        }
        if (orderService.count(duplicateQw) > 0) {
            return Result.failure("工单编号已存在");
        }
        return null;
    }

    private String nextOrderCode() {
        return "WO" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }

    private Date parsePlanTime(String value) {
        if (StringUtils.isBlank(value)) {
            return null;
        }
        List<String> patterns = Arrays.asList("yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", "yyyy-MM-dd");
        for (String pattern : patterns) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                sdf.setLenient(false);
                return sdf.parse(value);
            } catch (ParseException ignore) {
            }
        }
        return null;
    }

    private String statueName(Integer statue) {
        if (statue == null) return "未设置";
        switch (statue) {
            case 1:
                return "已创建/待审批";
            case 2:
                return "已审批";
            case 3:
                return "已结束";
            case 4:
                return "已终结";
            default:
                return "未知";
        }
    }

    private String customClass(Integer statue) {
        if (statue != null && statue == 3) return "ganttGreen";
        if (statue != null && statue == 4) return "ganttRed";
        return "ganttOrange";
    }

    private String cssClass(Integer statue) {
        return statue != null && statue == 4 ? "redLabel" : "";
    }

    private void fillDesigner(SpOrder order, SysUser user) {
        if (order == null || user == null) {
            return;
        }
        order.setDesignerId(user.getId());
        order.setDesignerName(displayUsername(user));
    }

    private SysUser currentUser() {
        try {
            return getSysUser();
        } catch (Exception ignore) {
            return null;
        }
    }

    private String displayUsername(SysUser user) {
        if (user == null) {
            return "";
        }
        return StringUtils.defaultIfBlank(user.getName(), user.getUsername());
    }

    private boolean canApproveOrder() {
        SysUser user = currentUser();
        if (!(user instanceof SysUserDTO)) {
            return false;
        }
        SysUserDTO dto = (SysUserDTO) user;
        if (dto.getSysRoleDTOs() == null) {
            return false;
        }
        for (SysRoleDTO role : dto.getSysRoleDTOs()) {
            if (role == null) {
                continue;
            }
            String code = role.getCode();
            if (ROLE_CODE_WAREHOUSE_MANAGER.equals(code)
                    || ROLE_CODE_SUPER_ADMIN.equals(code)
                    || ROLE_CODE_ADMIN.equals(code)) {
                return true;
            }
        }
        return false;
    }
}
