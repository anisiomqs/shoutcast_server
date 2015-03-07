defmodule Mp3FileTest do
  use ExUnit.Case

  test "returns the ID3 info" do
    id3 = Mp3File.extract_id3("./test/nederland.mp3")
    assert id3.artist == "Devil's Slingshot"
  end
end
