# Zadania Domowe Szkolenie Terraform: Zjazd 10

## Zadanie 1 - Jumphost

W tym zadaniu utwórz maszynę wirtualną z systemem operacyjnym Ubuntu, która będzie pełniła funkcję jumphosta.

Możesz wykorzystać moduł, który powstał podczas zjazdu 8 lub utworzyć własną maszynę wirtualną.

Przygotuj podsieć, która będzie wykorzystywana przez maszynę wirtualną.
Jumphost powinien mieć przypisany adres IP publiczny, który będzie wykorzystywany do połączenia się z AKS i innymi
prywatnymi zasobami.

Na maszynie wirtualnej zainstaluj narzędzia:

* Azure CLI
* Kubectl
* Helm

Pomocne linki:

* [Dokumentacja zasobu azurerm_linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)
* [Dokumentacja zasobu azurerm_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip)
* [Dokumentacja zasobu azurerm_network_interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)
* [Instalacja Azure CLI na Ubuntu](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt#option-1-install-with-one-command)
* [Instalacja Kubectl na Ubuntu](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-binary-with-curl-on-linux)
* [Instalacja Helm na Ubuntu](https://helm.sh/docs/intro/install/#from-script)

## Zadanie 2 - Zabezpieczenie dostępu do usług

W tym zadaniu zabezpieczymy dostęp do usług powstałych podczas projektu.

Należy wykonać następujące kroki:

* Utworzenie `azurerm_private_dns_zone_virtual_network_link` dla strefy DNS wykorzystywanej przez AKS do sieci shared,
  dzięki temu z poziomu Jumphosta będzie można połączyć się z klastrem AKS
* Wyłączenie publicznego dostępu do usługi Azure Container Registry
* Zabroń publicznego dostępu do usługi Azure Key Vault, pozostawiając dostęp ze swojego adresu IP i sieci aplikacyjnej
* Wyłącz publiczny dostęp do usługi Azure Cache for Redis

## Zadanie 3 - AKS Secret Provider

W ramach tego zadania aktywuj na AKS integrację z Key Vault, przy pomocy bloku `key_vault_secrets_provider`.
Do modułu aks dodaj outputy, który wyświetlą dane tożsamości wykorzystywanej przez key vault secret provider (object_id,
client_id).
Nadaj uprawnienia tożsamości Secret Providera do pobierania sekretów z Key Vault.

Pomocne linki:

* [Dokumentacja zasobu azurerm_kubernetes_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster)

## Zadanie 4 - Utworzenie sekretów w Key Vault

W ramach tego zadania utwórz w Key Vault następujące sekrety:

* DB-HOST - adres hosta bazy danych PostgreSQL
* DB-DATABASE - nazwa bazy danych
* DB-USERNAME - nazwa użytkownika do bazy danych
* DB-PASSWORD - hasło do bazy danych
* REDIS-HOST - adres hosta bazy Redis w formacie `tls://<hostname>`
* REDIS-PASSWORD - hasło do bazy Redis

Pomocne linki:

* [Dokumentacja zasobu azurerm_key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret)

## Zadanie 5 - Import obrazu i helm do ACR

W ramach tego zadania zaloguj się poprzez SSH na jump hosta i wykonaj polecenie:

```bash
ACR_SUBSCRIPTION_ID=""
ACR_NAME=""
az login # zaloguj się do Azure 
az account set -s $ACR_SUBSCRIPTION_ID # wybierz subskrypcję na której jest ACR
az acr import --name $ACR_NAME --source docker.io/dawidholka/chm-status:1.0.0
az acr import --name $ACR_NAME -t helm/dawidholka/chm-status:0.1.0 --source registry-1.docker.io/dawidholka/chm-status:0.1.0
```

## Zadanie 6 - Instalacja helm chart

W ramach tego zadania zainstaluj helm chart z aplikacją webową, która będzie korzystać z utworzonych w Key Vault
sekretów.

Korzystając z jumphost ustaw połączenie z AKS poprzez polecenie:

```bash
AKS_SUBSCRIPTION_ID=""
AKS_RESOURCE_GROUP_NAME=""
AKS_NAME=""
az account set -s $AKS_SUBSCRIPTION_ID
az aks get-credentials --resource-group $AKS_RESOURCE_GROUP_NAME --name $AKS_NAME

```

W kolejnym kroku wdroż aplikację webową, korzystając z helm chartu:

```bash
TENANT_ID="3a81269f-0731-42d7-9911-a8e9202fa750"
ACR_NAME=""
KEY_VAULT_NAME=""
USER_NAME="00000000-0000-0000-0000-000000000000"
ACR_SUBSCRIPTION_ID=""
SECRET_PROVIDER_CLIENT_ID="" # do pobrania z outputów modułu aks w zadaniu 3

az account set -s $ACR_SUBSCRIPTION_ID

PASSWORD=$(az acr login --name $ACR_NAME --expose-token --output tsv --query accessToken)
helm registry login $ACR_NAME.azurecr.io \
  --username $USER_NAME \
  --password $PASSWORD

helm pull oci://$ACR_NAME.azurecr.io/helm/dawidholka/chm-status

helm upgrade --install chm-status chm-status-0.1.0.tgz --install \
  --set image.repository=$ACR_NAME.azurecr.io/dawidholka/chm-status \
  --set config.APP_ENV="production" \
  --set config.APP_DEBUG="false" \
  --set secrets.KEY_VAULT_URI=$KEY_VAULT_NAME \
  --set secrets.TENANT_ID=$TENANT_ID \
  --set secrets.SECRET_PROVIDER_CLIENT_ID=$SECRET_PROVIDER_CLIENT_ID
```

Po instalacji wylistuj wdrożone serwisy na AKS i pobierz publiczny adres IP wykorzystywany przez aplikację webową:

```bash
kubectl get services -n=default # wylistowanie wdrożonych usług wyszukaj tej o nazwie chm-status
```

Do zdebugowania aplikacji możesz wykorzystać komendy:

```bash
kubectl get deployments -n=default # wylistowanie wdrożonych deploymentów

kubectl describe deployment <deployment_name> # wyświetlenie szczegółów wdrożonego deploymentu

kubectl get pods -n=default # wylistowanie wdrożonych podów

kubectl describe pod <pod_name> # wyświetlenie szczegółów wdrożonego poda

kubectl exec --stdin --tty <pod_name> -- php artisan health:check # wykonanie health check sprawdzającego połączenie do usług

kubectl logs <pod_name> # wyświetlenie logów z aplikacji
```
