defmodule Mp3FileTest do
  use ExUnit.Case

  test "returns the ID3 info" do
    id3 = Mp3File.extract_id3("./test/nederland.mp3")
    assert id3.title == "Nederland"
    assert id3.artist == "Devil's Slingshot"
    assert id3.album == "Clinophobia"

    id3 = Mp3File.extract_id3("./test/15-English Civil War.mp3")
    assert id3.title == "English Civil War"
    assert id3.artist == "The Clash"
    assert id3.album == "The Essential (CD1)"
  end

  test "expect extract metadata to return ID3 info" do
    metadata = Mp3File.extract_metadata("./test/nederland.mp3")
    assert String.starts_with?(metadata, "TAG")

    metadata = Mp3File.extract_metadata("./test/15-English Civil War.mp3")
    assert String.starts_with?(metadata, "TAG")
  end
end
