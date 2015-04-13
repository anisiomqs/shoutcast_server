defmodule ShoutcastServerTest do
  use ExUnit.Case
  require Socket

  test "the icy header" do
    actual = ShoutcastServer.icy_header
    expected = """
    ICY 200 OK\r
    icy-notice1: Elixir Shoutcast server<BR>\r
    icy-name: Elixir mix\r
    icy-genre: Rock\r
    icy-url: http://localhost:4040\r
    content-type: audio/mpeg\r
    icy-pub: 1\r
    icy-metaint: 24576\r
    icy-br: 96\r
    \r
    """
    assert actual == expected
  end

  test "the file descriptor" do
    actual = ShoutcastServer.file_descriptor("Lose your religion")
    # TODO fix this
    # << actual_size :: binary-size(1), _ :: binary >> = actual
    # actual_size = String.to_integer(actual_size) * 16
    # expected_size = byte_size(actual)

    # assert actual_size == expected_size
    assert << 5, "StreamTitle='Lose your religion';StreamUrl='http://localhost:4040';", _ :: binary-size(13)>> = actual
  end

  test "send icy request to server" do
    pid = spawn(fn ->
      ShoutcastServer.init
    end)

    socket = Socket.TCP.connect! "localhost", 4040
    icy_header = """
    GET / HTTP/1.1\r
    Host: localhost:4040\r
    x-audiocast-udpport: 63263\r
    icy-metadata: 1\r
    Accept: */*\r
    User-Agent: iTunes/12.1.2 (Macintosh; OS X 10.10.1) AppleWebKit/0600.1.25\r
    Cache-Control: no-cache\r
    Connection: close\r
    \r"
    """
    socket |> Socket.Stream.send! icy_header
    actual = socket |> Socket.Stream.recv!

    expected = """
    ICY 200 OK\r
    icy-notice1: Elixir Shoutcast server<BR>\r
    icy-name: Elixir mix\r
    icy-genre: Rock\r
    icy-url: http://localhost:4040\r
    content-type: audio/mpeg\r
    icy-pub: 1\r
    icy-metaint: 24576\r
    icy-br: 96\r
    \r
    """

    assert actual == expected

    Process.exit(pid, :kill)
  end
end
