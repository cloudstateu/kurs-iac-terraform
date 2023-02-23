# Zadania# Szkolenie Terraform: Zjazd 2

## Zadanie 1

Celem tego zadania jest nauczenie się korzystania ze zmiennych.

W ramach tego zadania należy stworzyć sieć wirtualną i podsieć przy pomocy zasobów `azurerm_virtual_network` oraz `azurerm_subnet`.
Nazwy zasobów i zakresy sieciowe sieci/podsieci umieść w zmiennych.
Wykorzystaj zmienną lokalną do wymuszenia prefixu w nazwach zasobów z Twoim numerem studenta.
Zasoby umieść w przygotowanej dla Ciebie grupie zasobów (będzie tu potrzebna data source).

Aby zrealizować to zadanie, należy wykonać następujące kroki:

1. Utwórz nowy folder i skonfiguruj w nim providera AzureRM.
2. Utwórz plik `data.tf` i umieść w nim data source reprezentujący Twoją grupę zasobów `azurerm_resource_group`.
3. Utwórz plik `variables.tf` i zdefiniuj w nim zmienne: `vnet_name`, `subnet_name`, `vnet_address_space` i `subnet_address_prefixes`.
4. Dodaj do pliku `variables.tf`, zmienne lokalne, które do nazwy podanej w zwykłych zmiennych dodadzą prefix.
5. Utwórz plik `network.tf` i dodaj do niego zasoby `azurerm_virtual_network` i `azurerm_subnet`, skonfiguruj je z wykorzystaniem zmiennych i zmiennych lokalnych.
6. Utwórz plik `terraform.tfvars` i przypisz wartości do zmiennej.
7. Uruchom polecenie `terraform plan`. Sprawdź, czy Terraform wykrył błędy w konfiguracji.
8. Spróbuj przekazać wartość zmiennej do konfiguracji Terraform na inne sposoby np. z poziomu opcji CLI -var, zmiennych
   środowiskowych TF_VAR_. Spróbuj przekazać wartość na kilka sposób jednocześnie i sprawdź efekt.


Pomocne linki:

* [Zasób azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
* [Zasób azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
* [Zmienne w terraform](https://developer.hashicorp.com/terraform/language/values/variables)
* [Pierwszeństwo definicji zmiennych](https://developer.hashicorp.com/terraform/language/values/variables#variable-definition-precedence)

## Zadanie 2

Celem tego zadania jest nauczenie się importowania zasobów do stanu.

W ramach tego zadania należy utworzyć ręcznie poprzez portal Azure nowy Storage Account, przygotować zasób w Terraform i zaimportować go.

Aby zrealizować to zadanie, należy wykonać następujące kroki:

1. Utwórz zasób Storage Account w portalu Azure.
2. Utwórz reprezentacje Storage Account w pliku Terraform.
3. Zaimportuj utworzony Storage Account przy pomocy polecenia `terraform import`.
4. Sprawdź zmiany w pliku stanu po zaimportowaniu zasobu.
5. Wykonaj polecenie `terraform plan` w celu sprawdzenia zgodności opisanego zasobu ze znajdującym się w chmurzę.

Pomocne linki:
* [Zasób azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
* [Komenda: terraform import](https://developer.hashicorp.com/terraform/cli/commands/import)
