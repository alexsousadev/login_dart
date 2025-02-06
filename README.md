## Configuração

Para configurar sua chave de API, siga os passos abaixo:


1. Rode o comando de contrução da aplicação Flutter:

   ```bash
   flutter pub get
   ```


1. **Adicionar a chave no HTML**: Inclua sua chave de API (do Google Maps) diretamente no seu arquivo HTML, modificando a tag `<head>` de seu `web/index.html` para carregar a API JavaScript do Google Maps, da seguinte forma: Por exemplo:
   ```html
   <head>
     <!-- Outras configurações -->
     <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY"></script>
   </head>
   ```

2. **Criar o arquivo `.env`**: Crie um arquivo chamado `.env` na raiz do seu projeto e adicione suas variáveis de ambiente no formato `NOME_VARIAVEL=valor` para configurar o Supabase:
   ```env
   API_KEY=sua_chave_aqui
   SUPABASE_URL=sua_url_aqui
   ```
