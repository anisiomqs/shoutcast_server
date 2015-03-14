defmodule Mp3File do
  def extract_metadata(file) do
    read_file = File.read!(file)
    file_length = byte_size(read_file)
    music_data = file_length - 128
    << _ :: binary-size(music_data), id3_section :: binary >> = read_file
    id3_section
  end

  defp parse_id3(metadata) do
    << _ :: binary-size(3), title :: binary-size(30), artist :: binary-size(30), album :: binary-size(30), _ :: binary >> = metadata
    %{
      title: sanitize(title),
      artist: sanitize(artist),
      album: sanitize(album)
    }
  end

  defp sanitize(text) do
    not_zero = &(&1 != <<0>>)
    text |> String.graphemes |> Enum.filter(not_zero) |> to_string |> String.strip
  end

  def extract_id3(file) do
    metadata = extract_metadata(file)
    parse_id3(metadata)
  end

  def extract_id3_list(folder) do
    folder |> Path.join("**/*.mp3") |> Path.wildcard |> Enum.map(&extract_id3/1)
  end
end
