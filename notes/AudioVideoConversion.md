## First - the alias!

```
alias ff='ffmpeg -hide_banner'
```

FFmpeg can be installed with `cinst -y imagemagick`.

## Fixin videos for Vegas/Movie Studio

Some MP4 videos (e.g. from Moto C Plus) can't be imported directly (different codec),
but just reconverting them is enough:

```
ff -i XY.mp4 out.mp4
```

Vegas can now import it and the file also gets considerably shorter without visible loss of quality.
At least for that phone (results probably may vary).

## Audio conversion

To OGG Q7 (`anything-to-ogg-44k1-q7.sh`):
```
#!/bin/sh

# ffmpeg installed as part of imagemagick or imagemagick.app (using chocolatey)
# this version also supports better libvorbis, unlike binary from ffmpeg web

# Usage with find: find . -iname \*.flac -exec anything-to-ogg-44k1-q7.sh {} \;

# filename must by in additional {} for protection of spaces
# -vn is no video (just in case of some cover image in flac file)
# -y to overwrite file
ffmpeg.exe -i "${1}" -ar 44100 -vn -codec:a libvorbis -qscale:a 7 -y "${1%.*}.ogg"
```

To MP3 for players that don't support OGG or FLAC.
This one is more sophisticated, it doesn't override original files and allows directory as the
last argument (`anything-to-mp3.sh`):
```
#!/bin/sh
# takes list of files to convert, can be ogg or any other format
# last param can be output dir (created if necessary, defaults to basedir of input file)
#
# ffmpeg installed as part of imagemagick or imagemagick.app (using chocolatey)
# this version also supports better libvorbis, unlike binary from ffmpeg web
#
# Usage with find: find . -name \*.flac -exec ./anything-to-ogg-44k1-q7.sh {} \;
# filename must by in additional {} for protection of spaces
# -vn is no video (just in case of some cover image in flac file)
# -y to overwrite the output file (input file is not changed of course)
#
# Example:
# anything-to-mp3.sh /f/music/ABBA/1979\ Voulez-Vous/*.ogg "ABBA 1979 Voluez-Vous"
#
# Example for multiple albums with output directory per album:
# for DIR in /f/music/Beatles/19[67]*; do
#   OUT="Beatles - "`basename "$DIR"`; anything-to-mp3.sh "$DIR"/*.mp3 "$OUT"
# done

# finds last argument: https://stackoverflow.com/a/1853993/658826
for last; do true; done

if [ -d "$last" -o ! -f "$last" ]; then
  OUTDIR="$last"
  mkdir -p "$OUTDIR"
  echo "Output to: $OUTDIR"
  
  # Setting new arg list without the last arg (only files to convert are there now)
  set -- "${@:1:$(($#-1))}"
fi

while [ -n "$1" ]; do
  # if we get to the last param that is used as output dir, we can exit (not necessary after set above)
  #[ "$OUTDIR" = "$1" ] && exit
  
  OUT="${1%.*}.mp3"
  if [ -n "$OUTDIR" ]; then
    OUT="$OUTDIR/"`basename "$OUT"`
  fi
  if [ "${1}" = "${OUT}" ]; then
    echo "Input and output file is the same! Exiting..."
    exit
  fi

  # quality 4~165kbps, 5~130 (lower is better): https://trac.ffmpeg.org/wiki/Encode/MP3
  # ffmpeg has its own quoting system, doesn't work well with single-quotes, so we redirect
  ffmpeg.exe -i pipe: -ar 44100 -vn -codec:a libmp3lame -qscale:a 4 -y "${OUT}" < "$1"
  
  shift
done
```
