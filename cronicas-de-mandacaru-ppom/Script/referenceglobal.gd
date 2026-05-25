extends Node

# Dicionário com todo o conteúdo de referência

var collected_items = {
	"notebook_1_paper": false,  # o papel do puzzle 1
	"notebook_2_paper": false,
}

var references = {
	"variaveis": {
		"title": "Variáveis",
		"content": """Uma variável é um espaço na memória para guardar um valor.

Exemplos em GDScript:

  var nome = "João"
  var idade = 25
  var ativo = true

Tipos comuns:
  • int   → números inteiros (1, 2, 42)
  • float → números decimais (3.14)
  • String → texto ("olá")
  • bool  → verdadeiro/falso"""
	},
	"funcoes": {
		"title": "Funções",
		"content": """Funções são blocos de código reutilizáveis.

  func somar(a, b):
      return a + b

  var resultado = somar(3, 4)  # → 7"""
	},
	# Adicione quantas quiser...
}
