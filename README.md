# Sinalize: app do cidadão (iOS)

> Projeto final da pós-graduação em desenvolvimento mobile do Instituto Infnet.

## Sobre o projeto

O **Sinalize** é um sistema para informar problemas na **sinalização de trânsito da cidade do Rio de Janeiro**. É formado por dois aplicativos iOS que se complementam:

- **sinalize** (este repositório): app do **cidadão**, que registra a solicitação.
- [sinalizetec](https://github.com/fabcurvello/sinalizetec): app da **área técnica**, usado pelos profissionais credenciados da CET-Rio para atender as solicitações.

Os dois apps compartilham o mesmo back-end no Firebase.

## Contexto acadêmico

Projeto final do curso de **pós-graduação em desenvolvimento mobile do Instituto Infnet**, feito por Fabricio Curvello.

## Funcionalidades

- Criação de conta e login com e-mail e senha (Firebase Authentication).
- Abertura de solicitação com endereço, ponto de referência, descrição do problema e foto.
- Localização no mapa para preencher o endereço.
- Histórico das solicitações do usuário, com número, data, status, técnico responsável e foto do atendimento.

## Arquitetura

- `Models/`: `Solicitacao`, `Usuario` e `Alerta`.
- `ViewControllers/`: telas de entrada, cadastro, nova solicitação, mapa, histórico e detalhes.

## Tecnologias

- **Swift 4**
- **UIKit** (Storyboards), **MapKit**
- **Firebase**: Authentication, Realtime Database e Storage
- **SDWebImage** (carregamento de imagens)
- **CocoaPods**
- iOS 11+

## Como executar

1. Clone o repositório e instale as dependências:
   ```bash
   git clone https://github.com/fabcurvello/sinalize.git
   cd sinalize
   pod install
   ```
2. Abra `sinalize.xcworkspace` no **Xcode** e execute no simulador.

> Projeto de 2018 (Swift 4). Versões atuais do Xcode podem pedir a conversão da sintaxe do Swift e a atualização dos pods.

## Veja também

- [sinalizetec](https://github.com/fabcurvello/sinalizetec): app da área técnica, que completa este projeto.

## Autor

**Fabricio Curvello**: professor de desenvolvimento de software no SENAI-RJ (desde 1997) e em faculdades do grupo Ânima Educação (IBMR e UNA).

- GitHub: [github.com/fabcurvello](https://github.com/fabcurvello)
- LinkedIn: [linkedin.com/in/fabriciocurvello](https://www.linkedin.com/in/fabriciocurvello)
- YouTube: [@fabriciocurvello](https://www.youtube.com/@fabriciocurvello)
