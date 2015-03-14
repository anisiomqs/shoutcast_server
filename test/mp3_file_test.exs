defmodule Mp3FileTest do
  use ExUnit.Case

  test "returns the ID3 info" do
    id3 = Mp3File.extract_id3("./test/fixtures/nederland.mp3")
    assert id3.title == "Nederland"
    assert id3.artist == "Devil's Slingshot"
    assert id3.album == "Clinophobia"

    id3 = Mp3File.extract_id3("./test/fixtures/15-English Civil War.mp3")
    assert id3.title == "English Civil War"
    assert id3.artist == "The Clash"
    assert id3.album == "The Essential (CD1)"
  end

  test "expect extract metadata to return ID3 info" do
    metadata = Mp3File.extract_metadata("./test/fixtures/nederland.mp3")
    assert String.starts_with?(metadata, "TAG")

    metadata = Mp3File.extract_metadata("./test/fixtures/15-English Civil War.mp3")
    assert String.starts_with?(metadata, "TAG")
  end

  test "retuns id3 list from directory" do
    id3_list = Mp3File.extract_id3_list("./test/fixtures")
    assert id3_list == [
      %{album: "The Essential (CD1)", artist: "The Clash", title: "English Civil War"},
      %{album: "Blunderbuss", artist: "Jack White", title: "Missing Pieces"},
      %{album: "Blunderbuss", artist: "Jack White", title: "Sixteen Saltines"},
      %{album: "Blunderbuss", artist: "Jack White", title: "Freedom at 21"},
      %{album: "LA Woman", artist: "the doors", title: "the changeling"},
      %{album: "LA Woman", artist: "the doors", title: "love her madly"},
      %{album: "LA Woman", artist: "the doors", title: "been down so long"},
      %{album: "Clinophobia", artist: "Devil's Slingshot", title: "Nederland"}
    ]
  end
end
