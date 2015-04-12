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
end
