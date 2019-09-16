# Coleta de Inventário

Aplicativo para coleta de inventário da UFRGS para a plataforma iOS, disponível na [App Store](https://apps.apple.com/br/app/coleta-de-inventário/id1476740242).

## Começando

Para clonar o repositório, escolha o link HTTPS e não o SSH (onde aparece SSH é só clicar que muda para o HTTPS).

### Pré-requisitos

Para gerenciamento de bibliotecas, foi utilizado CocoaPods.
Caso CocoaPods não esteja instalado, usar o seguinte comando:

```
$ sudo gem install cocoapods
```
### Sobre o projeto (XCode)

Sempre abrir o projeto com o arquivo `Inventário UFRGS.workspace` pois o mesmo contém todos os links de bibliotecas e pods. Quando o projeto é aberto com `Inventário UFRGS.xcodeproj` ele não será executável.

## Bibliotecas utilizadas

* `Alamofire`, `~> 4.0`
	* https://github.com/Alamofire/Alamofire
	* Serviços de API rest

* `SwiftyJSON`
	* https://github.com/SwiftyJSON/SwiftyJSON
	* Tratamento de arquivos JSON recebidos da API

* `SwiftOverlays`, `~> 3.0.0`
	* https://github.com/peterprokop/SwiftOverlays
	* Mostrar popups de carregamento

* `BarcodeScanner`, `2.1.2`
	* https://github.com/hyperoslo/BarcodeScanner
	* Leitura do código de barras dos patrimônios.


### Em caso de dúvidas

* Augusto Boranga (aboranga@inf.ufrgs.br)
* Lucas Flores (lsflores@inf.ufrgs.br)
