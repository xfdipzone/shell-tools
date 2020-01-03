# image-compress

批量压缩图片工具

---

## 介绍

使用 `shell` 实现一个小工具，检查目录及子目录中图片(`jpg`,`gif`,`png`)，将大于指定值的图片进行压缩处理。

---

## 使用说明

### 设定

`folder_path` 图片目录路径

`max_size` 图片大小允许值

`max_width` 图片最大宽度

`max_height` 图片最大高度

`quality` 图片质量

例如：

```shell
floder_path=/photo
max_size=1024k
max_width=1280
max_height=1280
quality=85
```

表示检查 `/photo` 目录及子目录中，大小大于 `1024k` 的图片，执行压缩处理

压缩为最大宽度 `1280` 最大高度 `1280` 质量 `85`

### 执行

```shell
# 执行压缩处理
./image-compress.sh
```
