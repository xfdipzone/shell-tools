# log-backup

Shell实现日志备份工具

---

## 介绍

使用 `shell` 实现的日志备份工具，配合 `crontab` 可以定时执行日志备份处理。

功能包括：

- 将日志文件复制到备份目录，并将原日志文件内容清空

- 自动创建日志备份目录

- 清理过期的日志备份文件

- 删除为空的日志备份目录

---

## 使用说明

**backup** 方法用于日志备份

调用格式：

> backup `$日志目录` `$日志备份目录`

例：

```shell
backup "/tmp/fdipzone/logs" "/tmp/fdipzone/logs/bak/2023/05/23"
```

&nbsp;

**clear_expire** 方法用于清理过期的日志备份文件及删除为空的日志备份目录

调用格式：

> clear_expire `$日志备份目录` `$日志备份过期时间`

例：清理 30 天前的日志

```shell
clear_expire "/tmp/fdipzone/logs/bak" 30
```
