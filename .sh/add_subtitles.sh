#!/bin/bash

# Script to add subtitles to video with Source Han font
# Usage: ./add_subtitles.sh <input_video> <subtitle_file> [output_video]

# Check if arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <input_video> <subtitle_file> [output_video]"
    echo "Example: $0 ringRevisit.mp4 ringRevisit.srt"
    echo "         $0 video.mp4 subtitle.srt output.mp4"
    exit 1
fi

INPUT_VIDEO="$1"
SUBTITLE_FILE="$2"

# If output file is specified, use it; otherwise generate from input filename
if [ -n "$3" ]; then
    OUTPUT_VIDEO="$3"
else
    # Remove extension and add _with_subs
    FILENAME="${INPUT_VIDEO%.*}"
    EXTENSION="${INPUT_VIDEO##*.}"
    OUTPUT_VIDEO="${FILENAME}_with_subs.${EXTENSION}"
fi

# Check if input files exist
if [ ! -f "$INPUT_VIDEO" ]; then
    echo "Error: $INPUT_VIDEO not found!"
    exit 1
fi

if [ ! -f "$SUBTITLE_FILE" ]; then
    echo "Error: $SUBTITLE_FILE not found!"
    exit 1
fi

echo "Input video: $INPUT_VIDEO"
echo "Subtitle file: $SUBTITLE_FILE"
echo "Output video: $OUTPUT_VIDEO"
echo ""

# Add subtitles with Source Han Sans font styling using GPU acceleration
echo "Using GPU acceleration (NVIDIA NVENC)..."
ffmpeg -hwaccel cuda -i "$INPUT_VIDEO" \
    -vf "subtitles=$SUBTITLE_FILE:force_style='\
FontName=Source Han Sans SC,\
FontSize=20,\
PrimaryColour=&HFFFFFF,\
OutlineColour=&H000000,\
Outline=2,\
Shadow=1,\
Bold=1,\
MarginV=30,\
Alignment=2'" \
    -c:v h264_nvenc -preset p4 -cq 23 \
    -c:a copy \
    "$OUTPUT_VIDEO"

if [ $? -eq 0 ]; then
    echo "Success! Output saved to: $OUTPUT_VIDEO"
else
    echo "Error: ffmpeg command failed"
    exit 1
fi
