#!/bin/bash
actions="${1:-}"

if [[ "${actions}" = "d" || "${actions}" = "b" ]]; then
  printf "\n--- deploy/kubernetes delete --------------------------------------\n"
  kubectl -k deploy/kubernetes delete

  printf "\n--- deploy/client delete ------------------------------------------\n"
  kubectl -k examples/kubernetes/davfs-client delete

  printf "\n--- deploy/server delete ------------------------------------------\n"
  kubectl -k examples/kubernetes/davfs-server delete

  printf "\n--- namespace delete ----------------------------------------------\n"
  kubectl -f examples/kubernetes/Namespace.example.yaml delete
fi

if [[ "${actions}" = "c" || "${actions}" = "b" ]]; then
  printf "\n--- namespace create ----------------------------------------------\n"
  kubectl -f examples/kubernetes/Namespace.example.yaml create

  printf "\n--- deploy/kubernetes create --------------------------------------\n"
  kubectl -k deploy/kubernetes create

  printf "\n--- deploy/server create ------------------------------------------\n"
  kubectl -k examples/kubernetes/davfs-server create
  sleep 30

  printf "\n--- deploy/client create ------------------------------------------\n"
  # kubectl -k examples/kubernetes/davfs-client create
  kubectl -f examples/kubernetes/davfs-client/PersistentVolume.yaml create
  kubectl -f examples/kubernetes/davfs-client/PersistentVolumeClaim.yaml create
  sleep 30
  kubectl -f examples/kubernetes/davfs-client/Deployment.nginx.yaml create
fi
