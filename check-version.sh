#!/bin/bash

req_url='https://api.us-east-1.gallery.ecr.aws/describeImageTags'
req_body="{\"registryAliasName\":\"karpenter\",\"repositoryName\":\"karpenter\"$nextToken}"

charts_dir="charts"

str_token="nd"
while [ $str_token != "null" ]
do
  req_body="{\"registryAliasName\":\"karpenter\",\"repositoryName\":\"karpenter\"$nextToken}"
  req_resp="$(curl -s $req_url -d $req_body)"
  str_token="$(echo $req_resp |jq -r '.nextToken')"
  images="$images$(echo $req_resp |jq '.imageTagDetails[]')"
  nextToken=",\"nextToken\":\"$(echo $req_resp |jq -r '.nextToken')\""
done

tags=($(echo $images |jq -r 'select(.imageDetail.artifactMediaType == "application/vnd.cncf.helm.config.v1+json") | .imageTag'))

verify=0
for i in "${tags[@]}"; do
  if [ "$charts_dir/karpenter-$i.tgz" != "$(find $charts_dir -name karpenter-$i.tgz)" ]; then
    helm pull oci://public.ecr.aws/karpenter/karpenter -d $charts_dir --version $i
    ((verify++))
  fi
done

if [ $verify != 0 ]; then
  helm repo index --url https://pablommr.github.io/helm-charts/ .
fi

echo "VERIFY=$verify" >> $GITHUB_ENV
echo "$verify updated"