defmodule ShotcastServer do
  def start(port) do
    {:ok, socket} = :gen_tcp.listen(port,[:binary, packet: :line, active: false])
    spawn(Server,accept,[])
  end
end
