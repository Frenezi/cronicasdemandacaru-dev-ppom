extends Node

# ─── FLAGS DE ITENS COLETADOS ──────────────────────────────────────────────────

var collected_items = {
	"paper_1": false,
	"tutorial_niede_paper": false,
	"paper_2" : false 
}

# ─── CONTEÚDO DE REFERÊNCIA ────────────────────────────────────────────────────

var references = {
	"variaveis": {
		"title": "Variáveis",
		"content": """Uma variável é um espaço na memória para guardar um valor.

Exemplos:

  var nome = "João"
  var idade = 25
  var ativo = true

Tipos comuns:
  • int    → números inteiros  (1, 2, 42)
  • float  → números decimais  (3.14)
  • String → texto             ("olá")
  • bool   → verdadeiro/falso  (true/false)"""
	},
	"pinturas": {
		"title": "Pinturas Rupestres",
		"content": "Pinturas rupestres são desenhos feitos nas rochas por povos antigos"
	}
}
