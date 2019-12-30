# monitor-kill-expire-process

监控并终止超时进程工具

---

## 介绍

使用 `shell` 实现一个小工具，监控指定进程并把运行超时的进程终止。

---

## 使用说明

### 设定

`process_config` 设置要监控的进程关键字，及进程超时时间。

例如：

```shell
readonly process_config=('mytest.php,120')
```

**mytest.php** 为监控进程的关键字

**120** 为进程运行的超时时间（秒）

### 执行

一般是使用定时任务 `crontab` 调用

```shell
* * * * * /monitor_kill_expire_process.sh
```
