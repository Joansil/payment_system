%Credo.Config{
  checks: [
    # Desabilita a verificação de doc no módulo
    {Credo.Check.Readability.ModuleDoc, false},
    # Desabilita a verificação de doc na função
    {Credo.Check.Readability.FunctionDoc, false}
  ],
  # Ajusta a severidade para warnings menos graves
  severity: :low
}
