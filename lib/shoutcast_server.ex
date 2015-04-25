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
  @folder "test/fixtures/"

  def init do
    :random.seed(:os.timestamp)
    server = Socket.TCP.listen!(@port, packet: 0)
    IO.puts "Server listening in http://localhost:#{@port}"
    accept(server)
  end

  def accept(server) do
    client = server |> Socket.TCP.accept!
    pid = spawn_link(ShoutcastServer,:accept, [server])
    IO.inspect(pid)
    recv(client)
  end

  def stream_folder(client) do
    songs = Mp3File.list(@folder)
    Enum.shuffle(songs) |> Enum.each(fn song ->
      client |> send_file(File.read!(song), Mp3File.extract_id3(song))
    end)
    stream_folder(client)
  end

  def recv(client) do
    case Socket.Stream.recv(client) do
      {:ok, data} ->
        if String.contains?(String.downcase(data), "icy-metadata: 1") do
          Socket.Stream.send!(client, icy_header)
          stream_folder(client)
        end
      {:error, reason} -> IO.inspect(reason)
    end
  end

  def close(client) do
    client |> Socket.close
  end

  def send_file(_client, "", _) do
    :ok
  end

  def send_file(client, file, %{ title: title } = file_info) do
    chunk = min(byte_size(file), @chunksize)
    padding = @chunksize - chunk
    padding = String.duplicate(<<0>>, padding)
    << file_part :: binary-size(chunk), file :: binary >> = file
    payload = file_part <> padding <> file_descriptor(title)
    client |> Socket.Stream.send!(payload)
    send_file(client, file, file_info)
  end

  def icy_header do
    ["ICY 200 OK\r\n",
     "icy-notice1: Elixir Shoutcast server<BR>\r\n",
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
