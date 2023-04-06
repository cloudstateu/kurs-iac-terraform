# Zadanie Szkolenie Terraform: Zjazd 7

## Zadanie 1 - Moduł VM

Przygotuj moduł, który tworzy maszynę wirtualną, interfejs sieciowy (wraz z opcjonalnym publicznym adresem ip). Dodaj
odpowiedni alias dla providera azure w konfiguracji modułu np. `virtual-machine`.

Moduł powinien tworzyć zasoby:

* Publiczny adres ip (jeśli odpowiednia zmienna przyjmie wartość `true`).
* Interfejs sieciowy.
* Maszyna wirtualna linux (logowanie przy pomocy hasła).

Moduł powinien przyjmować takie zmienne wejściowe (wraz z odpowiednim typowaniem):

* use_public_ip
* resource_group_name
* location
* admin_username
* admin_password
* virtual_machine_name
* subnet_id
* source_image (obiekt zawierający konfigurację wykorzystywanego obrazu systemu)

Na wyjściu z modułu ustaw:

* ID Maszyn wirtualnej
* Publiczny adres IP maszyny
* Prywatny adres IP maszyny

W przypadku zmiennej wejściowej przechowującej dane na temat systemu operacyjnego ustaw domyślną wartość z Ubuntu 16.04.
Jeśli jakieś zmienne nie są podane, przyjmij stałe wartości np. rozmiar maszyny.

Przetestuj moduł, tworząc dwie maszyny wirtualne, tylko jedna z nich powinna posiadać publiczny adres IP.

Pomocne linki:
* [Dokumentacja zasobu azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
* [Dokumentacja zasobu azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
* [Dokumentacja zasobu azurerm_network_interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface)
* [Dokumentacja zasobu azurerm_linux_virtual_machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)
* [Dokumentacja na temat aliasowania providerów](https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations)
* [Aliasowanie providerów w ramach modułu](https://developer.hashicorp.com/terraform/language/providers/configuration#alias-multiple-provider-configurations)
