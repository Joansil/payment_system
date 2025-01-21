%Credo.Config{
  checks: [
    {Credo.Check.Readability.ModuleDoc, false},  # Desabilita a verificação de doc no módulo
    {Credo.Check.Readability.FunctionDoc, false},  # Desabilita a verificação de doc na função
    {Credo.Check.Readability.SpaceAfterCommas, false},  # Desabilita warning de espaços após vírgulas
    {Credo.Check.Refactoring.RedundantWithElse, false}, # Ignora avisos sobre `with` com apenas um cláusula
  ],
  severity: :low,  # Ajusta a severidade para warnings menos graves
}
