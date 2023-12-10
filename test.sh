#!/bin/bash -e

tmpdir=$(mktemp -d)

cleanup() {
  rm -rf "$tmpdir"
}

trap cleanup EXIT SIGHUP SIGINT SIGQUIT SIGPIPE SIGTERM

if [ "$#" -ne 1 ]; then
    echo "Script name: $0 <src_file>"
    exit
fi

src_file="$1"

if [ ! -f "$src_file" ]; then
    echo "File <$src_file> not found."
    exit
fi

if [ ! -r "$src_file" ]; then
    echo "No access for <$src_file>."
    exit
fi

output=$(grep '&Output:' "$src_file" | cut -d ':' -f 2)

if [ -z "$output" ]; then
    echo "Comment '\$Output: <filename>.out' not found in source file."
    exit
fi

g++ -o "$tmpdir/executable" "$src_file"

if [ $? -ne 0 ]; then
  echo "Compilation failed."
  exit
fi

mv "$tmpdir/executable" "$output"

echo "Compilation successful. Output file: $output"
