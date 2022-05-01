#!/bin/bash
namespace=$1
statefulset_name=$2

unready_pods=$(kubectl -n "$namespace" get pods -o go-template='{{range $index, $element := .items}}{{range .status.containerStatuses}}{{if not .ready}}{{$element.metadata.name}}{{"\n"}}{{end}}{{end}}{{end}}' | grep "$statefulset_name")

for pod in $unready_pods
do
  kubectl exec -ti "$pod" -n vault -- vault operator unseal "$KEY_1"
  kubectl exec -ti "$pod" -n vault -- vault operator unseal "$KEY_2"
  kubectl exec -ti "$pod" -n vault -- vault operator unseal "$KEY_3"
done

