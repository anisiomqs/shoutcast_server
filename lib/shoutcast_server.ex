defmodule ShoutcastServer do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # worker(ShoutcastServer.Worker, [arg1, arg2, arg3])
    ]

    opts = [strategy: :one_for_one, name: ShoutcastServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @chunksize 24576
  @port 4040
  @song "test/fixtures/nederland.mp3"

  def init do
    server = Socket.TCP.listen!(@port, packet: 0)
    IO.puts "Server listening in http://localhost:#{@port}"
    client = server |> Socket.TCP.accept!
    recv(client)
  end

  def recv(client) do
    case Socket.Stream.recv(client) do
      {:ok, data} ->
        if String.contains?(data, "icy-metadata: 1") do
          Socket.Stream.send!(client, icy_header)
          client |> send_file(File.read!(@song), Mp3File.extract_id3(@song))
        end
      {:error, reason} -> IO.inspect(reason)
    end
  end

  def close(client) do
    client |> Socket.close
  end

  def send_file(client, file, %{ title: title } = file_info) do
    << file_part :: binary-size(@chunksize), file :: binary >> = file
    payload = file_part <> file_descriptor(title)
    client |> Socket.Stream.send!(payload)
    send_file(client, file, file_info)
  end

  def icy_header do
    ["ICY 200 OK\r\n",
     "icy-notice1: <BR>This stream requires",
     "<a href=\"http://www.winamp.com/\">Winamp</a><BR>\r\n",
     "icy-notice2: Erlang Shoutcast server<BR>\r\n",
     "icy-name: Elixir mix\r\n",
     "icy-genre: Rock\r\n",
     "icy-url: http://localhost:#{@port}\r\n",
     "content-type: audio/mpeg\r\n",
     "icy-pub: 1\r\n",
     "icy-metaint: ", Integer.to_string(@chunksize), "\r\n",
     "icy-br: 96\r\n\r\n"] |> List.to_string
  end

  def file_descriptor(title) do
    bin = ["StreamTitle='", title , "';StreamUrl='http://localhost:#{@port}';"] |> List.to_string
    blocks = div( byte_size(bin) - 1, 16) + 1
    pad = blocks*16 - byte_size(bin)
    extra = List.duplicate 0, pad
    [blocks, bin, extra] |> List.to_string
  end
end
