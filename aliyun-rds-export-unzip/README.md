# aliyun-rds-export-unzip

阿里云 RDS 导出数据库结构整理工具

---

## 介绍

使用 `shell` 实现一个小工具，可以整理阿里云 RDS 导出数据库结构的 `zip` 文件，整理为可直接使用的 `sql` 文件。

---

## 阿里云 RDS 导出的数据库结构sql需要整理的地方

### 1. 解压后 sql 文件名称缺少数据库名称标识

阿里云 RDS 导出的数据库结构 sql，会压缩为一个 zip 文件，解压后的 sql 文件名称没有带上数据库名。

例如：

数据库名称是：`test_user`

导出后的zip文件名称： `test_user_1616950_all_sql.zip`

解压后的sql文件名称： `1616950_all.sql`

如果同时存在多个数据库导出文件，这样比较难去区分，因此需要对解压后的文件重命名，带上数据库名称。

### 2. 附带不需要用到的设定数据

因为只导出结构，并不需要数据，因此我们并不需要获取之前数据库表的 AUTO_INCREMENT 设定，对于类似这种的设定，也需要去掉。

### 3. 解压后的 sql 文件为 utf8 bom

如果我们使用 php 代码读取这个 sql 文件执行，sql 文件带 utf8 bom 会导致执行出错，因此需要把 sql 文件的 utf8 bom 头去掉。

---

## 整理步骤

1.解压文件

2.解压后文件按数据表名重命名

3.删除 `AUTO_INCREMENT` 及 `ROW_FORMAT` 设定参数

4.去掉文件的 `utf8 bom` 头

`test_user_1616950_all_sql.zip` 执行脚本处理后，会生成 `test_user.sql` 文件

去掉 SQL 文件内容的 `AUTO_INCREMENT` 及 `ROW_FORMAT` 设定参数与文件编码的 `utf8 bom` 头
