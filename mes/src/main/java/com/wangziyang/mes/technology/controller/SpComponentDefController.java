package com.wangziyang.mes.technology.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.SpComponentDef;
import com.wangziyang.mes.technology.request.SpComponentDefReq;
import com.wangziyang.mes.technology.service.ISpComponentDefService;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Component definition controller.
 */
@Controller
@RequestMapping("/technology/component")
public class SpComponentDefController extends BaseController {

    @Autowired
    private ISpComponentDefService componentDefService;

    @ApiOperation("零部件定义列表页")
    @GetMapping("/list-ui")
    public String listUI() {
        return "technology/component/list";
    }

    @ApiOperation("零部件新增/编辑页")
    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpComponentDef record) {
        if (StringUtils.isNotEmpty(record.getId())) {
            model.addAttribute("result", componentDefService.getById(record.getId()));
        } else {
            SpComponentDef init = new SpComponentDef();
            init.setComponentCode(componentDefService.nextComponentCode());
            init.setComponentType("COMP");
            init.setDeleted("0");
            model.addAttribute("result", init);
        }
        return "technology/component/addOrUpdate";
    }

    @ApiOperation("零部件选择弹窗")
    @GetMapping("/select-ui")
    public String selectUI(Model model,
                           @RequestParam(required = false) String productName,
                           @RequestParam(required = false) String componentType) {
        model.addAttribute("productName", productName != null ? productName : "");
        model.addAttribute("componentType", componentType != null ? componentType : "");
        return "technology/component/select";
    }

    @ApiOperation("零部件分页查询")
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpComponentDefReq req) {
        QueryWrapper<SpComponentDef> qw = new QueryWrapper<>();
        if (StringUtils.isNotEmpty(req.getProductNameLike())) {
            String productNameLike = normalizeProductName(req.getProductNameLike());
            qw.and(w -> w.like("product_name", productNameLike)
                    .or()
                    .like("product_name", productNameLike + "?")
                    .or()
                    .like("product_name", productNameLike + "？"));
        }
        if (StringUtils.isNotEmpty(req.getComponentCodeLike())) {
            qw.likeRight("component_code", req.getComponentCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getComponentNameLike())) {
            qw.like("component_name", req.getComponentNameLike());
        }
        if (StringUtils.isNotEmpty(req.getComponentType())) {
            String componentType = normalizeComponentType(req.getComponentType());
            if ("PG".equals(componentType)) {
                qw.in("component_type", "PG", "半成品");
            } else if ("COMP".equals(componentType)) {
                qw.in("component_type", "COMP", "组件");
            } else {
                qw.eq("component_type", req.getComponentType());
            }
        }
        if (StringUtils.isNotEmpty(req.getDeleted())) {
            qw.eq("is_deleted", req.getDeleted());
        } else {
            qw.ne("is_deleted", "1");
        }
        qw.orderByDesc(req.getOrderBy());
        IPage result = componentDefService.page(req, qw);
        return Result.success(result);
    }

    @ApiOperation("零部件新增/编辑")
    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpComponentDef record) {
        if (StringUtils.isEmpty(record.getProductName())) {
            return Result.failure("请输入产品名称");
        }
        if (StringUtils.isEmpty(record.getComponentName())) {
            return Result.failure("请输入零部件名称");
        }
        record.setProductName(normalizeProductName(record.getProductName()));
        record.setComponentName(record.getComponentName().trim());
        if (StringUtils.isEmpty(record.getComponentCode())) {
            record.setComponentCode(componentDefService.nextComponentCode());
        }
        if (StringUtils.isEmpty(record.getComponentType())) {
            record.setComponentType("COMP");
        }
        record.setComponentType(normalizeComponentType(record.getComponentType()));
        if (!"PG".equals(record.getComponentType()) && !"COMP".equals(record.getComponentType())) {
            return Result.failure("零部件类型只能为半成品或组件");
        }
        if (StringUtils.isEmpty(record.getDeleted())) {
            record.setDeleted("0");
        }
        if (componentDefService.isComponentCodeDuplicate(record.getComponentCode(), record.getId())) {
            return Result.failure("零部件编号已存在");
        }
        if (componentDefService.isComponentNameDuplicate(
                record.getProductName(), record.getComponentName(), record.getId())) {
            return Result.failure("该产品下零部件名称已存在");
        }
        componentDefService.saveOrUpdate(record);
        return Result.success(record.getId());
    }

    private String normalizeProductName(String productName) {
        return StringUtils.trimToEmpty(productName).replaceAll("[?？]+$", "");
    }

    private String normalizeComponentType(String componentType) {
        String type = StringUtils.trimToEmpty(componentType);
        if ("半成品".equals(type)) {
            return "PG";
        }
        if ("组件".equals(type)) {
            return "COMP";
        }
        return type;
    }

    @ApiOperation("启用/禁用零部件")
    @PostMapping("/disable")
    @ResponseBody
    public Result disable(@RequestParam String id, @RequestParam String status) {
        SpComponentDef record = new SpComponentDef();
        record.setId(id);
        record.setDeleted(status);
        componentDefService.updateById(record);
        return Result.success();
    }

    @ApiOperation("删除零部件")
    @PostMapping("/delete")
    @ResponseBody
    public Result delete(@RequestParam String id) {
        SpComponentDef record = new SpComponentDef();
        record.setId(id);
        record.setDeleted("1");
        componentDefService.updateById(record);
        return Result.success();
    }

    @ApiOperation("按产品查询可用零部件")
    @GetMapping("/selectable")
    @ResponseBody
    public Result selectable(@RequestParam(required = false) String productName,
                             @RequestParam(required = false) String componentType) {
        List<SpComponentDef> list = componentDefService.listEnabledByProductName(productName, componentType);
        if (list.isEmpty() && StringUtils.isNotEmpty(productName)) {
            list = componentDefService.listEnabledByProductName(null, componentType);
        }
        if (list.isEmpty() && StringUtils.isNotEmpty(componentType)) {
            list = componentDefService.listEnabledByProductName(productName, null);
        }
        if (list.isEmpty() && (StringUtils.isNotEmpty(productName) || StringUtils.isNotEmpty(componentType))) {
            list = componentDefService.listEnabledByProductName(null, null);
        }
        return Result.success(list);
    }
}
