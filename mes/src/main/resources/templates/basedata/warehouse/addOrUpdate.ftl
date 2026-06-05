<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>库房编辑</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <#include "${request.contextPath}/common/common.ftl">
</head>
<body>
<div class="splayui-container">
    <div class="splayui-main">
        <form class="layui-form splayui-form" lay-filter="formTest">
            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 10px;">
                <legend style="font-size:14px;">基本信息</legend>
            </fieldset>
            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label for="js-warehouseCode" class="layui-form-label sp-required">库房编码</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-warehouseCode" name="warehouseCode" lay-verify="required"
                                   autocomplete="off" class="layui-input" value="${result.warehouseCode}">
                        </div>
                    </div>
                </div>
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label class="layui-form-label sp-required">库房类型</label>
                        <div class="layui-input-inline">
                            <select name="warehouseType" lay-verify="required">
                                <option value="">请选择库房类型</option>
                                <option value="1" <#if (result.warehouseType)?? && result.warehouseType == "1">selected</#if>>零件库</option>
                                <option value="2" <#if (result.warehouseType)?? && result.warehouseType == "2">selected</#if>>产品库</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label for="js-warehouseName" class="layui-form-label sp-required">库房名称</label>
                        <div class="layui-input-inline">
                            <input type="text" id="js-warehouseName" name="warehouseName" lay-verify="required"
                                   autocomplete="off" class="layui-input" value="${result.warehouseName}">
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-form-item layui-form-text">
                <label for="js-warehouseDesc" class="layui-form-label">库房描述</label>
                <div class="layui-input-block" style="margin-left: 110px;">
                    <textarea id="js-warehouseDesc" name="warehouseDesc" class="layui-textarea"
                              placeholder="请输入库房描述">${result.warehouseDesc}</textarea>
                </div>
            </div>

            <fieldset class="layui-elem-field layui-field-title" style="margin-top: 10px;">
                <legend style="font-size:14px;color:#FF5722;">库房规格信息（保存后按 组×排×层×列 自动生成库位）</legend>
            </fieldset>
            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label for="js-specGroup" class="layui-form-label sp-required">组</label>
                        <div class="layui-input-inline">
                            <input type="number" id="js-specGroup" name="specGroup" min="1" lay-verify="required|number"
                                   autocomplete="off" class="layui-input" value="${result.specGroup}">
                        </div>
                    </div>
                </div>
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label for="js-specRow" class="layui-form-label sp-required">排</label>
                        <div class="layui-input-inline">
                            <input type="number" id="js-specRow" name="specRow" min="1" lay-verify="required|number"
                                   autocomplete="off" class="layui-input" value="${result.specRow}">
                        </div>
                    </div>
                </div>
            </div>
            <div class="layui-row">
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label for="js-specLayer" class="layui-form-label sp-required">层</label>
                        <div class="layui-input-inline">
                            <input type="number" id="js-specLayer" name="specLayer" min="1" lay-verify="required|number"
                                   autocomplete="off" class="layui-input" value="${result.specLayer}">
                        </div>
                    </div>
                </div>
                <div class="layui-col-xs6 layui-col-sm6 layui-col-md6">
                    <div class="layui-form-item">
                        <label for="js-specColumn" class="layui-form-label sp-required">列</label>
                        <div class="layui-input-inline">
                            <input type="number" id="js-specColumn" name="specColumn" min="1" lay-verify="required|number"
                                   autocomplete="off" class="layui-input" value="${result.specColumn}">
                        </div>
                    </div>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label sp-required">状态</label>
                <div class="layui-input-block" style="width: 310px;">
                    <input type="radio" name="deleted" value="0" title="正常"
                           <#if (result.deleted)?? && result.deleted == "2">  <#else> checked </#if>>
                    <input type="radio" name="deleted" value="2" title="禁用"
                           <#if (result.deleted)?? && result.deleted == "2"> checked </#if>>
                </div>
            </div>

            <div class="layui-form-item layui-hide">
                <div class="layui-input-block">
                    <input id="js-id" name="id" value="${result.id}"/>
                    <button id="js-submit" class="layui-btn" lay-submit lay-filter="js-submit-filter">确定</button>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    layui.use(['form'], function () {
        var form = layui.form;

        //监听提交
        form.on('submit(js-submit-filter)', function (data) {
            spUtil.submitForm({
                url: "${request.contextPath}/basedata/warehouse/add-or-update",
                data: data.field
            });
            return false;
        });
    });
</script>
</body>
</html>
