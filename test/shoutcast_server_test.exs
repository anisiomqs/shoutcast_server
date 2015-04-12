defmodule ShoutcastServerTest do
  use ExUnit.Case

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
    << actual_size :: binary-size(1), _ :: binary >> = actual
    # TODO fix this
    # actual_size = String.to_integer(actual_size) * 16
    # expected_size = byte_size(actual)

    # assert actual_size == expected_size
    assert << 5, "StreamTitle='Lose your religion';StreamUrl='http://localhost:4040';", rest :: binary-size(13)>> = actual
  end
end
