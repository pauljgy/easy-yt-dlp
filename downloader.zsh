#!/bin/zsh

# Check if a filename was provided
if [[ -z "$1" ]]; then
    echo "Usage: $0 <links_file.txt>"
    exit 1
fi

while IFS= read -r link || [[ -n "$link" ]]; do
    # Skip comments and empty lines
    [[ -z "$link" || "$link" == \#* ]] && continue

    # Parse based on the platform
    case "$link" in
        *youtube.com*|*youtu.be*)
            # Removes the '&' and everything after it
            clean_link="${link%%&*}"
            ;;
        *soundcloud.com*)
            # Removes the '?' and everything after it
            # (The backslash \? is used to ensure the shell treats it as a literal ?)
            clean_link="${link%%\?*}"
            ;;
        *)
            clean_link="$link"
            ;;
    esac

    # Remove any accidental trailing whitespace
    clean_link="${clean_link%%[[:space:]]}"

    echo "--- Downloading: $clean_link ---"
    yt-dlp -x --audio-format mp3 --embed-metadata "$clean_link"

done < "$1"

echo "--- All downloads complete! ---"