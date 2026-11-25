#!/bin/bash

set -o nounset
set -o errexit

# ==========================================
# Kubernetes ConfigMap 关键词搜索及服务追踪工具
# 支持搜索 Key 和 Value
#
# Date:     2026-11-11
# Author:   fdipzone
# Ver:      1.0
#
# Example:
# 参数1：命名空间（选填，空表示 ALL）
# 参数2：关键字（必填）
# ./k8s_configmap_search.sh staging-data-collector AWS_S3_BUCKET
# ./k8s_configmap_search.sh '' AWS_S3_BUCKET
# ==========================================

NS="${1:-}"
KEYWORD="${2:-}"

if [[ -z "$KEYWORD" ]]; then
    echo "Usage: $0 <namespace|空> <keyword>"
    echo "Example 1: $0 staging-data-collector AWS_S3_BUCKET"
    echo "Example 2: $0 '' AWS_S3_BUCKET"
    exit 1
fi

for cmd in kubectl jq; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: $cmd is not installed"
        exit 1
    fi
done

if [[ -n "$NS" ]]; then
    SCOPE_ARGS=(-n "$NS")
    echo "Namespace : $NS"
else
    SCOPE_ARGS=(-A)
    echo "Namespace : ALL"
fi

echo "Keyword   : $KEYWORD"

# 获取 ConfigMap
CM_JSON=$(kubectl get configmap "${SCOPE_ARGS[@]}" -o json) || exit 1

# 搜索 Key 和 Value
MATCHES=$(echo "$CM_JSON" | jq -r --arg kw "$KEYWORD" '
.items[] as $cm |
($cm.data // {} | to_entries[]) |
select(
    (.key | test($kw; "i")) or
    (.value | test($kw; "i"))
) |
[
    $cm.metadata.namespace,
    $cm.metadata.name,
    .key,
    .value
] | @tsv
')

if [[ -z "$MATCHES" ]]; then
    echo "No matching ConfigMap found."
    exit 0
fi

echo
echo "========== MATCHED CONFIGMAP =========="

while IFS=$'\t' read -r ns cm key value; do
    echo
    echo "Namespace : $ns"
    echo "ConfigMap : $cm"
    echo "Key       : $key"
    echo "Value     : $value"

    echo
    echo "---------- REFERENCED WORKLOADS ----------"

    # 获取常见 Kubernetes 工作负载
    kubectl get deploy,sts,ds,job,cronjob,pod \
    -n "$ns" -o json |
    jq -r --arg cm "$cm" '
    .items[] as $obj |
    (
        if $obj.kind == "CronJob" then
            $obj.spec.jobTemplate.spec.template.spec
        elif $obj.kind == "Job" then
            $obj.spec.template.spec
        elif $obj.kind == "Pod" then
            $obj.spec
        else
            $obj.spec.template.spec
        end
    ) as $spec |

    [
        ($spec.volumes[]? | .configMap.name?),
        ($spec.volumes[]? | .projected.sources[]?.configMap.name?),
        ($spec.containers[]? | .envFrom[]?.configMapRef.name?),
        ($spec.containers[]? | .env[]?.valueFrom.configMapKeyRef.name?),
        ($spec.initContainers[]? | .envFrom[]?.configMapRef.name?),
        ($spec.initContainers[]? | .env[]?.valueFrom.configMapKeyRef.name?)
    ] |

    select(any(.[]; . == $cm)) |

    "\($obj.kind)/\($obj.metadata.name)"
    '
done <<< "$MATCHES"

echo
echo "=========================================="
echo "Search completed."
echo "=========================================="
