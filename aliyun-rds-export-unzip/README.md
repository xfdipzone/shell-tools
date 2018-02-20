# aliyun-rds-export-unzip
阿里云RDS导出数据库结构整理工<br><br>

## 介绍
使用shell实现一个小工具，可以整理阿里云RDS导出数据库结构的zip文件，整理为可直接使用的sql文件。<br><br>

## 阿里云RDS导出的数据库结构sql需要整理的地方
### 1.解压后sql文件名称缺少数据库名称标识
阿里云RDS导出的数据库结构sql，会压缩为一个zip文件，解压后的sql文件名称没有带上数据库名。<br><br>
例如<br><br>
数据库名称是test_user<br>
导出后的zip文件名称： test_user_1616950_all_sql.zip<br>
解压后的sql文件名称： 1616950_all.sql<br><br>
如果同时存在多个数据库导出文件，这样比较难去区分，因此需要对解压后的文件重命名，带上数据库名称。<br><br>
### 2.附带不需要用到的设定数据
因为只导出结构，并不需要数据，因此我们并不需要获取之前数据库表的AUTO_INCREMENT设定，对于类似这种的设定，也需要去掉。<br><br>
### 3.解压后的sql文件为utf8 bom
如果我们执行这个sql创建数据表是使用例如php代码读取后执行，sql文件带utf8 bom会导致执行出错，因此需要把sql文件的utf8 bom头去掉。<br><br>


## 整理步骤
1.解压文件<br><br>
2.解压后文件按数据表名重命名<br><br>
3.删除`AUTO_INCREMENT`及`ROW_FORMAT`设定参数<br><br>
4.去掉文件的`utf8 bom`头
