# k8s-configmap-search

Kubernetes ConfigMap 关键词搜索及服务追踪

---

## 介绍

使用 `shell` 实现的一个工具，用于搜索 Kubernetes 集群中配置项设置（可搜索 Key 与 Value）

找出集群中含有这个关键词的配置项以及使用这个配置项的应用与容器列表

---

## 使用说明

**参数1 命名空间：**

Namespace 选填，为空则表示搜索集群中所有命名空间

**参数2 关键字：**

Keyword 必填，用于搜索集群配置项中的 key 与 value

---

## 执行

```shell
# 执行脚本
/k8s_configmap_search.sh '' AWS_S3_BUCKET

# 输出
Namespace : ALL
Keyword   : AWS_S3_BUCKET

========== MATCHED CONFIGMAP ==========

Namespace : staging-data-collector
ConfigMap : staging-data-config
Key       : AWS_S3_BUCKET
Value     : data-uat

---------- REFERENCED WORKLOADS ----------
Deployment/staging-cms
Deployment/staging-data-api
Deployment/staging-data-daemon
Deployment/staging-data-daemon-kafka
Deployment/staging-job-schedule
Deployment/staging-worker-service
Pod/staging-cms-7d7d4548cd-srtt6
Pod/staging-data-api-59d6f87cdd-gwdc6
Pod/staging-data-daemon-59cd7ccffc-hwwwn
Pod/staging-job-schedule-6df9c6585f-7ggfj
Pod/staging-worker-service-6d46cd8bbb-cvjnr
Pod/staging-worker-service-6d46cd8bbb-ffnd8

==========================================
Search completed.
==========================================
```
