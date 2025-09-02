# 🐝 TaskHive

Aplicação de **gerenciamento de tarefas** desenvolvida em **Flutter** como projeto pessoal de estudo.  
A proposta foi criar uma solução simples, mas escalável, explorando integração com backend, gerenciamento de estado e notificações locais.

---

## 🔑 Principais destaques
- 📋 **CRUD completo** de tarefas com persistência no **Supabase**.  
- 🔔 **Notificações agendadas** usando `awesome_notifications` (5 minutos antes e no horário da tarefa).  
- ⚡ **Gerenciamento de estado com Provider (ChangeNotifier)**, garantindo reatividade da UI.  
- 📅 **Filtros por data** para visualizar apenas as tarefas do dia selecionado.  
- 📝 **Formulário dinâmico** para criação/edição de tarefas (prioridade, data e horário de notificação).  
- 🎨 **UI moderna** com **Slidable** para ações rápidas (editar/excluir), indicadores de prioridade e conclusão.  

---

## 🛠️ Stack utilizada
- [Flutter](https://flutter.dev/) – Framework principal.  
- [Supabase](https://supabase.com/) – Banco de dados e API REST.  
- [Provider](https://pub.dev/packages/provider) – Gerenciamento de estado (MVVM).  
- [Awesome Notifications](https://pub.dev/packages/awesome_notifications) – Notificações locais.  

---

## 📐 Arquitetura
O código foi estruturado em camadas:

lib/
┣ core/ # Serviços e constantes globais
┣ data/ # Models e Repositórios (acesso a dados)
┣ viewmodels/ # Lógica de negócio (Provider)
┣ views/ # UI e widgets (camada de apresentação)
┗ main.dart # Inicialização do app

➡️ Esse padrão segue o **MVVM (Model–View–ViewModel)**, inspirado em boas práticas de **Clean Architecture**, garantindo:  
- Separação clara de responsabilidades;  
- Facilidade de manutenção;  
- Evolução e expansão sem impacto direto na interface.  

---

## 🚀 Como rodar o projeto
1. Clone este repositório:
   ```bash
   git clone https://github.com/seuusuario/taskhive.git
   cd taskhive

2. Instale as dependências:
flutter pub get


3. Configure o arquivo app_keys.dart com suas chaves do Supabase.

4. Execute o app:
flutter run
