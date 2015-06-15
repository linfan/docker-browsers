模板生成器
---

自动根据各个目录中的`AutoGen.conf`文件生成相应的Dockerfile、Makefile、Readme.md和Entrypoint.sh文件。

使用方法：

```
./generator.sh <浏览器> <生成文件>
```

支持的浏览器参数值：`firefox` / `chrome` / `all` (可缩写为 f、c 和 a)<br>
支持的生成文件参数值：`entrypoint` / `dockerfile` / `makefile` / `readme` / `all` (可缩写为 e 、d 、m、r 和 a)<br>
默认参数为均为：`all`

