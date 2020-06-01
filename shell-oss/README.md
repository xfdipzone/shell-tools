# shell-oss

Shell实现OSS上传，下载，删除工具

---

## 介绍

使用 `shell` 实现一个小工具，提供OSS的上传，下载，删除功能。

---

## 使用说明

### 设定

```shell
# OSS配置
readonly endpoint="${OSS_ENDPOINT}"
readonly bucket="${OSS_BUCKET}"
readonly access_id="${OSS_ACCESS_ID}"
readonly access_key="${OSS_ACCESS_KEY}"
```

### 执行

上传

```shell
./shell_oss.sh put local.png oss.png
```

下载

```shell
./shell_oss.sh get oss.png local.png
```

删除

```shell
./shell_oss.sh del oss.png
```
