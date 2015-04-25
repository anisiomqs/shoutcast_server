Shoutcast Server
==============

Simple Shoutcast Server written in Elixir.

It's functional, but very raw.

To do:

* Extract ID3 from files; `Done`
* List mp3 files from directory; `Done`
* Allow multiple clients; `Done`
* Random playlist
  - When song ends, select next from playlist and stream it
* Handle disconnection
  - integrate :gen_server
