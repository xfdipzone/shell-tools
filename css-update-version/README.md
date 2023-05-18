# css-update-version

更新CSS文件内引用文件版本工具

---

## 介绍

使用 `shell` 实现一个小工具，可以更新CSS文件内引用文件的版本。

前端版本更新时，需要更新CSS，及CSS里面引用的文件，例如图片，字体等。但是文件路径是不改变的，只是替换文件而已，这样浏览器在加载时会获取文件缓存而不是获取最新的文件使用。

此工具可以对CSS文件内引用的文件进行更新，使引用文件路径带上时间参数作为版本。浏览器加载时因为新版本的路径没有加载过，则会当作新的文件加载。

例如：

```txt
如background:url('images/test.jpg'); 更新为 background:url('images/test.jpg?20191224121212')
```

---

## 使用说明

### 设定

`css_path` CSS真实使用的文件路径，存放更新完版本后的CSS文件。

`css_tmpl_path` CSS模版文件存放的路径，所有CSS模版文件内引用的文件都不带版本号，程序会遍历此文件目录下所有CSS模版文件读取内容，更新版本，然后写入 `css_path` 文件目录对应文件。

`replace_tags` 需要替换版本的引用文件后缀，例如 `.jpg`, `.git`, `.png`等。

### 参数

`search_child` 是否遍历子目录 1:表示遍历子目录 0:表示不遍历子目录。

### 执行

```shell
# 不遍历子目录
./css-update-version.sh 0

# 遍历子目录
./css-update-version.sh 1
```
