const express = require("express");
const cors = require("cors");
const app = express();

app.use(cors());
app.use(express.json());

let pessoas = require("./data");

// GET - listar todas
app.get("/pessoas", (req, res) => {
  res.json(pessoas);
});

// POST - adicionar nova pessoa
app.post("/pessoas", (req, res) => {
  const novaPessoa = {
    id: pessoas.length ? pessoas[pessoas.length - 1].id + 1 : 1,
    ...req.body
  };
  pessoas.push(novaPessoa);
  res.status(201).json(novaPessoa);
});

// GET - pessoa por ID
app.get("/pessoas/:id", (req, res) => {
  const pessoa = pessoas.find(p => p.id === parseInt(req.params.id));
  if (!pessoa) return res.status(404).json({ mensagem: "Pessoa não encontrada" });
  res.json(pessoa);
});

// DELETE - deletar pessoa
app.delete("/pessoas/:id", (req, res) => {
  pessoas = pessoas.filter(p => p.id !== parseInt(req.params.id));
  res.status(204).send();
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`API rodando na porta ${PORT}`));
