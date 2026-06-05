# CLAUDE.md

本文件指导 Claude Code 在本仓库中工作。MES 制造执行系统，Spring Boot 单模块（代码均在 `mes/`）。

## 构建与运行

**必须**通过项目内的 `.codex-maven-settings.xml` 调用 Maven（它指定阿里云镜像 + 项目内本地仓库 `.m2/repository`）。不带 `-s` 直接 `mvn` 会因镜像/离线问题失败。

```powershell
# 启动应用（跳过测试）
mvn -s .\.codex-maven-settings.xml -f .\mes\pom.xml -DskipTests spring-boot:run

# 仅编译 / 打包
mvn -s .\.codex-maven-settings.xml -f .\mes\pom.xml -DskipTests compile
mvn -s .\.codex-maven-settings.xml -f .\mes\pom.xml -DskipTests package
```

- 启动后访问 `http://localhost:9090`（`server.port=9090`，无 context-path）。
- 默认 profile = `dev`（见 `mes/src/main/resources/application.yml`）。
- 需要 MySQL（dev 连 `127.0.0.1:3306/sparchetype`）和 Redis（`127.0.0.1:6379`）。

## 技术栈

Java 11 · Spring Boot · MyBatis-Plus · Druid · MySQL · Redis · EhCache · Shiro（鉴权）· FreeMarker（`.ftl` 模板）· 前端 layui + 自封装 `sp*` 组件（`spTable`/`spLayer`/`spUtil`）。

## 目录约定

- Java 源码根包：`com.wangziyang.mes`，按业务域分包：`basedata`（基础数据）、`technology`（工艺）、`system`（用户/角色/菜单/部门）等。每个域内：`controller` / `entity` / `mapper` / `request` / `service` / `service.impl`。
- MyBatis XML：`mes/src/main/resources/mapper/{域}/XxxMapper.xml`。
- FreeMarker 模板：`mes/src/main/resources/templates/{域}/{模块}/list.ftl|addOrUpdate.ftl|select.ftl`。
- 静态资源：`mes/src/main/resources/static/`（含 `js/layuimodule/sp/` 自封装组件）。
- 数据库迁移脚本：`scripts/sql/`，命名 `{feature}-upgrade-YYYYMMDD.sql`，**手动执行**（无自动 Flyway/Liquibase）。脚本需可重复执行（`IF NOT EXISTS` / `INFORMATION_SCHEMA` 列存在判断 / `INSERT IGNORE` / `NOT EXISTS` 子查询）。

## CRUD 模块范式（新增模块务必照此对齐现有代码）

- **实体**：继承 `common.BaseEntity`（提供 `id` 雪花串、`createTime/createUsername/updateTime/updateUsername` 自动填充）；`@TableName("sp_xxx")`；软删字段用 `@TableField("is_deleted") private String deleted;`；仅展示用的联表字段加 `@TableField(exist=false)`。
- **软删约定**：`is_deleted` 取值 `0`正常 / `1`删除 / `2`禁用。查询统一 `ne("is_deleted","1")` 或 `eq("is_deleted","0")`，不物理删除。
- **Controller**：`@Controller` + 继承 `common.BaseController`；`@RequestMapping("/{域}/{模块}")`；`*-ui` 的 `@GetMapping` 返回模板路径字符串；数据接口用 `@PostMapping + @ResponseBody` 返回 `common.Result`（`Result.success(data)` / `Result.failure(msg)` / `Result.success(data, msg)`）。
- **分页**：请求对象继承 `common.BasePageReq`（含 `current`/`size`/`orderBy`）；返回 MyBatis-Plus `IPage`；前端 `spTable` 的 `parseData` 读取 `res.data.records` / `res.data.total`。
- **Service/Mapper**：`IService`/`ServiceImpl` + `BaseMapper`；自定义联表查询写在 Mapper 接口 + 对应 XML。
- **唯一性校验**：在 Service 实现 `isXxxCodeDuplicate(code, excludeId)`（`ne is_deleted '1'`，编辑排除自身），保存前在 Controller 调用。
- **菜单**：存于 `sp_sys_menu` 表，通过 SQL 脚本 `INSERT IGNORE` 注册，并向 `sp_sys_role_menu` 授权（管理员 role code `888888`）。

## 前端范式

- 列表页用 `spTable.render`（POST 取数）+ `script[type=text/html]` 工具栏模板；编辑用 `spLayer.open({content: '.../add-or-update-ui', spWhere:{id}, spCallback})`。
- 主从布局（选主表行→刷新从表）参考 `templates/basedata/team/list.ftl`。
- 选择弹窗回传：子页设置 `window.spChildFrameResult = {code:0, data:[...]}`，父页 `spCallback(res)` 接收；参考 `templates/basedata/team/employeeSelect.ftl`、`processing-unit/team-select.ftl`。

## 注意

- 改完代码后用上面的 `compile` 命令编译验证（IDE 启动也可）。
- 数据库结构变更：新增 `scripts/sql/*-upgrade-*.sql` 并执行，不要直接改库结构而不留脚本。
- 提交信息、注释、UI 文案以中文为主，跟随现有风格。
- git 不出现claude任何内容（例如不出现Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>）