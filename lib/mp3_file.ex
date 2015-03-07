defmodule Mp3File do
  def extract_id3(file) do
    read_file = File.read!(file)
    file_length = byte_size(read_file)
    music_data = file_length - 128
    << _ :: binary-size(music_data), id3_section :: binary >> = read_file
    IO.inspect id3_section
  end
end
