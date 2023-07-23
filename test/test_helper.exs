ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Rockelivery.Repo, :manual)

# we let's defined a mock
Mox.defmock(Rockelivery.ViaCep.BehaviourMock, for: Rockelivery.ViaCep.Behaviour)
