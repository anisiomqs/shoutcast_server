defmodule Mp3FileTest do
  use ExUnit.Case

  # test "returns the ID3 info" do
  #   id3 = Mp3File.extract_id3("./test/nederland.mp3")
  #   assert id3.artist == "Devil's Slingshot"
  # end

  test "returns the ID3 info" do
    metadata = Mp3File.extract_metadata("./test/nederland.mp3")
    assert String.starts_with?(metadata, "TAG")
  end

  test "returns the metadata" do
    metadata = Mp3File.extract_metadata("./test/15-English Civil War.mp3")
    assert String.starts_with?(metadata, "TAG")
  end

end
