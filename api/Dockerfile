# Etapa base: usa imagem oficial do Node.js
FROM node:18

# Cria diretório de trabalho dentro do container
WORKDIR /app

# Copia os arquivos package.json e package-lock.json (se tiver)
COPY package*.json ./

# Instala as dependências do projeto
RUN npm install

# Copia o restante dos arquivos (index.js, data.js, etc.)
COPY . .

# Expõe a porta 3000 (a mesma usada na sua API)
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["node", "index.js"]
