# Auto Unsealer for Hashicorp Vault on Kubernetes

- Hashicorp vault doesn't provide an easy way to unseal the vault when deployed in HA mode.
- This repo solves that problem by unsealing pods which are not in ready state


## Manual One Time Setup

### Secrets 
- Get unseal keys after first-time deployment with helm charts using 
  - `kubectl exec -ti <vault-statefulset-pod-name> -n vault -- vault operator init`
- Create secret with name `vault-unseal-keys` and add 3 or whatever unlock threshold set (might have to update cron)
  - add keys with name `key_1`, `key_2` or `key_3` etc

### Update Namespace & deployment in cron.yaml
- Update arguments in line 57 of `cron.yaml` with your namespace & statefulset-name

## Deployment
- `configmap.yaml` contains the shell script used to unseal the vault pods
- `sa.yaml` contains YAMLs to create service account and give needed roles for applying it
- `cron.yaml` contains kubernetes Cron Job that runs every minute to unseal vault
