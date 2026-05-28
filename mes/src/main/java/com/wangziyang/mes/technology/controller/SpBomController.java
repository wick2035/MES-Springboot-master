package com.wangziyang.mes.technology.controller;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.technology.entity.SpBom;
import com.wangziyang.mes.technology.request.SpBomReq;
import com.wangziyang.mes.technology.service.ISpBomService;
import com.wangziyang.mes.technology.vo.BomTreeNodeVO;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.List;

/**
 * <p>
 * BOM前端控制器
 * </p>
 *
 * @author WangZiYang
 * @since 2020-03-28
 */
@Controller
@RequestMapping("/technology/bom")
public class SpBomController extends BaseController {

    @Autowired
    private ISpBomService iSpBomService;

    @ApiOperation("工艺BOM管理界面UI")
    @GetMapping("/list-ui")
    public String listUI(Model model) {
        return "technology/bom/list";
    }

    @ApiOperation("工艺BOM管理修改界面")
    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpBom spBom) throws Exception {
        if (StringUtils.isNotEmpty(spBom.getId())) {
            SpBom result = iSpBomService.getById(spBom.getId());
            model.addAttribute("result", result);
        }
        return "technology/bom/addOrUpdate";
    }

    @ApiOperation("BOM树形结构查看界面")
    @GetMapping("/tree-ui")
    public String treeUI(Model model, String id) {
        if (StringUtils.isNotEmpty(id)) {
            SpBom bom = iSpBomService.getById(id);
            model.addAttribute("bom", bom);
            model.addAttribute("bomId", id);
        }
        return "technology/bom/tree";
    }

    @ApiOperation("子BOM选择弹框界面")
    @GetMapping("/select-bom-panel-ui")
    public String selectBomPanelUI(Model model,
                                   @RequestParam(required = false) String itemMatType) {
        model.addAttribute("itemMatType", itemMatType != null ? itemMatType : "");
        return "technology/bom/selectBomPanel";
    }

    @ApiOperation("工艺BOM分页查询")
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpBomReq req) {
        QueryWrapper qw = new QueryWrapper();
        if (StringUtils.isNotEmpty(req.getMaterielCodeLike())) {
            qw.likeRight("materiel_code", req.getMaterielCodeLike());
        }
        IPage result = iSpBomService.page(req, qw);
        return Result.success(result);
    }

    @ApiOperation("工艺BOM修改、新增（仅头信息）")
    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpBom spBom) {
        iSpBomService.saveOrUpdate(spBom);
        return Result.success();
    }

    @ApiOperation("保存BOM头及全部子项（事务）")
    @PostMapping("/save-with-items")
    @ResponseBody
    public Result saveWithItems(SpBom spBom,
                                @RequestParam(required = false) String itemsJson) {
        iSpBomService.saveBomWithItems(spBom, itemsJson);
        return Result.success();
    }

    @ApiOperation("获取完整BOM树数据")
    @GetMapping("/tree-data")
    @ResponseBody
    public Result bomTreeData(@RequestParam String bomId) {
        try {
            BomTreeNodeVO tree = iSpBomService.buildBomTree(bomId, new HashSet<>());
            return Result.success(tree);
        } catch (IllegalStateException e) {
            return Result.failure(e.getMessage());
        }
    }

    @ApiOperation("获取可选子BOM列表")
    @GetMapping("/selectable-boms")
    @ResponseBody
    public Result selectableBoms(@RequestParam(required = false) String itemMatType) {
        List<SpBom> boms = iSpBomService.listSelectableBoms(itemMatType);
        return Result.success(boms);
    }

    @ApiOperation("BOM定版操作（锁定后不可编辑）")
    @PostMapping("/lock")
    @ResponseBody
    public Result lock(SpBom spBom) {
        try {
            iSpBomService.lockBom(spBom.getId());
            return Result.success();
        } catch (Exception e) {
            return Result.failure(e.getMessage());
        }
    }

    @ApiOperation("删除工艺BOM")
    @PostMapping("/delete")
    @ResponseBody
    public Result deleteByTableNameId(SpBom spBom) throws Exception {
        iSpBomService.removeById(spBom.getId());
        return Result.success();
    }
}
