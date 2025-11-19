# 🌤️ AppClima

> Um aplicativo Flutter simples e elegante que consulta a API do OpenWeather para mostrar o tempo atual e previsão.

---

## 🚀 Visão Geral
- **O que é:** Cliente móvel/web feito em Flutter que exibe o clima atual e previsão para uma cidade pesquisada.
- **Objetivo:** Demonstrar consumo de API, parsing seguro de JSON, UI modularizada e tema dinâmico conforme a temperatura.

---

## ✨ Funcionalidades principais
- Pesquisa de cidade (campo de busca) 🔎
- Exibição do tempo atual: cidade, descrição, ícone e temperatura 🌡️
- Painel de estatísticas: vento, umidade, pressão, mín./máx. 📊
- Previsão (forecast) em lista horizontal (cards) 📅
- Tema dinâmico: cores e gradiente mudam conforme a temperatura 🎨
- Tratamento de erros amigável (cidade não encontrada, timeout) ⚠️

---

## 📁 Estrutura do projeto (resumida)
- `lib/main.dart` — ponto de entrada; inicia o `WeatherHome`.
- `lib/config.dart` — configurações (cidade padrão, chave da API).
- `lib/Service/services.dart` — faz as requisições ao OpenWeather (tempo atual e forecast).
- `lib/Model/weather_model.dart` — classes que representam os dados retornados pela API.
- `lib/Screen/weather_home.dart` — tela principal; carrega dados, decide paleta de cores e monta os widgets.
- `lib/Screen/widgets/` — widgets de UI:
  - `weather_head.dart` — cabeçalho (cidade, data, hora, descrição).
  - `weather_body.dart` — corpo (ícone + temperatura).
  - `weather_footer.dart` — estatísticas (vento, umidade, pressão, etc.).
  - `forecast_list.dart` — lista horizontal de previsão.

---

## 🧭 Como funciona (resumido)
1. Ao abrir, o app carrega dados para a cidade padrão ou para a cidade pesquisada.
2. Duas requisições são feitas em paralelo: tempo atual e forecast.
3. Quando os dados chegam, a tela é atualizada e o tema (cores/gradiente) é definido conforme a temperatura.
4. Se algo falhar (ex.: cidade não encontrada), uma mensagem clara é exibida ao usuário.

---

## ▶️ Rodando o projeto (PowerShell)
1. Instalar dependências:
```powershell
flutter pub get
```
2. Rodar no Chrome (web):
```powershell
flutter run -d chrome
```
3. Rodar em dispositivo Android/Emulador (exemplo):
```powershell
flutter devices
flutter run -d <DEVICE_ID>
```

---

## 🔐 Chave da API — segurança
- Atualmente a chave do OpenWeather pode estar no arquivo `lib/config.dart`. **Não** exponha essa chave em repositórios públicos.
- Alternativas seguras:
  - Usar `--dart-define` e ler com `String.fromEnvironment('OPENWEATHER_API_KEY')`.
  - Usar `flutter_dotenv` e adicionar `.env` ao `.gitignore`.
  - Colocar a lógica sensível em um backend próprio e ocultar a chave.

---

## 🛠️ Boas práticas e sugestões de melhorias
- Adicionar cache para reduzir chamadas à API (ex.: `shared_preferences`).
- Filtrar forecast para 1 previsão por dia (melhor visualização).
- Animações suaves ao trocar paleta (AnimatedContainer). 
- Adicionar testes unitários para parsing e mocks para `WeatherServices`.
- Remover a chave da API do histórico git se já foi comitada (rotacionar chave).

---

## 📚 Referências rápidas
- Endpoint OpenWeather: `https://api.openweathermap.org/data/2.5/weather` e `/forecast`.
- Pacotes usados: `http`, `intl`, `flutter` (material).

---


