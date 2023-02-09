# helm-charts
Helm charts repository

## Setup chart (Karpenter)

1 - Download .tgz from public AWS repo:

```
helm pull oci://public.ecr.aws/karpenter/karpenter --version v0.23.0
````

Obs** change --version to version desired

<br>

2 - To create new index.yaml:
```
helm repo index --url https://pablommr.github.io/helm-charts/ .
```

Obs** Create Github page to expose helm chart

<br>

To update existing index to update version (download new .tgz first):
```
helm repo index --url https://pablommr.github.io/helm-charts/ --merge index.yaml .
```