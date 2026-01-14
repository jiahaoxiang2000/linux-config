#!/bin/bash

# Video Processor Script for OBS Recordings
# Features: Trim videos, normalize audio, add background music, and combine

set -e

# Print messages
print_info() {
    echo "[INFO] $1"
}

print_success() {
    echo "[SUCCESS] $1"
}

print_warning() {
    echo "[WARNING] $1"
}

print_error() {
    echo "[ERROR] $1"
}

# Check dependencies
check_dependencies() {
    print_info "Checking dependencies..."
    if ! command -v ffmpeg &> /dev/null; then
        print_error "FFmpeg is not installed. Please install it first."
        exit 1
    fi
    print_success "FFmpeg is installed"
}

# Helper function to parse time format (HH:MM:SS or seconds)
parse_time() {
    local time_input="$1"
    if [[ "$time_input" =~ ^[0-9]+:[0-9]+:[0-9]+$ ]]; then
        # Already in HH:MM:SS format
        echo "$time_input"
    elif [[ "$time_input" =~ ^[0-9]+$ ]]; then
        # Convert seconds to HH:MM:SS
        local hours=$((time_input / 3600))
        local minutes=$(((time_input % 3600) / 60))
        local seconds=$((time_input % 60))
        printf "%02d:%02d:%02d\n" "$hours" "$minutes" "$seconds"
    else
        print_error "Invalid time format: $time_input. Use HH:MM:SS or seconds"
        exit 1
    fi
}

# Trim video by removing portions from start and/or end
trim_video() {
    local input_file="$1"
    local output_file="$2"
    local start_trim="$3"  # Duration to trim from start (optional)
    local end_trim="$4"     # Duration to trim from end (optional)

    print_info "Trimming video: $input_file"

    # Get video duration
    local duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input_file")
    duration=${duration%.*}  # Round to integer

    print_info "Original video duration: $duration seconds"

    local start_time="0"
    local end_time="$duration"

    # Calculate start time (trim from beginning)
    if [[ -n "$start_trim" && "$start_trim" != "0" ]]; then
        start_trim=$(parse_time "$start_trim")
        local start_seconds=$(echo "$start_trim" | awk -F: '{print $1*3600 + $2*60 + $3}')
        start_time="$start_seconds"
        print_info "Trimming $start_seconds seconds from start"
    fi

    # Calculate end time (trim from end)
    if [[ -n "$end_trim" && "$end_trim" != "0" ]]; then
        end_trim=$(parse_time "$end_trim")
        local end_seconds=$(echo "$end_trim" | awk -F: '{print $1*3600 + $2*60 + $3}')
        end_time=$((duration - end_seconds))
        print_info "Trimming $end_seconds seconds from end"
    fi

    local duration_trim=$((end_time - start_time))

    if [[ $duration_trim -le 0 ]]; then
        print_error "Invalid trim parameters. Resulting duration would be negative or zero."
        exit 1
    fi

    print_info "New duration: $duration_trim seconds"

    # Perform the trim
    ffmpeg -i "$input_file" -ss "$start_time" -t "$duration_trim" -c:v libx264 -c:a aac -y "$output_file" -loglevel warning

    print_success "Video trimmed successfully: $output_file"
}

# Analyze audio volume and get mean volume in dB
analyze_audio_volume() {
    local input_file="$1"

    print_info "Analyzing audio volume for: $input_file" >&2

    local stats=$(ffmpeg -i "$input_file" -af "volumedetect" -vn -sn -dn -f null /dev/null 2>&1 | grep -E "mean_volume|max_volume")

    local mean_volume=$(echo "$stats" | grep "mean_volume" | awk '{print $5}')
    local max_volume=$(echo "$stats" | grep "max_volume" | awk '{print $5}')

    print_info "Mean volume: ${mean_volume} dB" >&2
    print_info "Max volume: ${max_volume} dB" >&2

    echo "$mean_volume"
}

# Normalize audio to a target volume
normalize_audio() {
    local input_file="$1"
    local output_file="$2"
    local target_volume="${3:--16}"  # Default -16 dB (EBU R128 standard)

    print_info "Normalizing audio to ${target_volume} dB"

    # Get current mean volume
    local current_volume=$(analyze_audio_volume "$input_file")
    current_volume=${current_volume%.*}  # Remove decimal

    # Calculate needed adjustment
    local adjustment=$((target_volume - current_volume))

    print_info "Adjusting volume by ${adjustment} dB"

    # Apply volume adjustment
    ffmpeg -i "$input_file" -af "volume=${adjustment}dB" -c:v copy -y "$output_file" -loglevel warning

    print_success "Audio normalized: $output_file"
}

# Mix video audio with background music
mix_with_background_music() {
    local video_file="$1"
    local background_music="$2"
    local output_file="$3"
    local music_volume="${4:-0.3}"  # Default music volume 30%
    local video_audio_volume="${5:-1.0}"  # Default video audio volume 100%

    print_info "Mixing video with background music"
    print_info "Background music volume: ${music_volume}"
    print_info "Video audio volume: ${video_audio_volume}"

    # Get video duration
    local video_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$video_file")
    video_duration=${video_duration%.*}

    # Loop background music to match video duration
    local temp_music="temp_looped_music_${RANDOM}.mp3"
    ffmpeg -stream_loop -1 -i "$background_music" -t "$video_duration" -c copy -y "$temp_music" -loglevel warning

    # Mix audio tracks
    ffmpeg -i "$video_file" -i "$temp_music" \
        -filter_complex "[0:a]volume=${video_audio_volume}[va];[1:a]volume=${music_volume}[ba];[va][ba]amix=inputs=2:duration=first" \
        -c:v copy -c:a aac -y "$output_file" -loglevel warning

    # Clean up temporary file
    rm -f "$temp_music"

    print_success "Audio mixed successfully: $output_file"
}

# Full processing pipeline
process_video() {
    local input_video="$1"
    local background_music="$2"
    local output_video="$3"
    local start_trim="$4"
    local end_trim="$5"
    local target_volume="${6:--16}"
    local music_volume="${7:-0.3}"

    print_info "Starting full video processing pipeline..."

    # Generate temp filenames
    local temp_trimmed="temp_trimmed_${RANDOM}.mp4"
    local temp_normalized="temp_normalized_${RANDOM}.mp4"

    # Step 1: Trim video
    if [[ -n "$start_trim" || -n "$end_trim" ]]; then
        trim_video "$input_video" "$temp_trimmed" "$start_trim" "$end_trim"
        input_video="$temp_trimmed"
    fi

    # Step 2: Normalize video audio
    print_info "Normalizing video audio..."
    normalize_audio "$input_video" "$temp_normalized" "$target_volume"
    input_video="$temp_normalized"

    # Step 3: Add background music
    if [[ -n "$background_music" && -f "$background_music" ]]; then
        mix_with_background_music "$input_video" "$background_music" "$output_video" "$music_volume"
    else
        print_warning "No background music provided or file not found. Copying video..."
        cp "$input_video" "$output_video"
    fi

    # Cleanup
    rm -f "$temp_trimmed" "$temp_normalized"

    print_success "Video processing complete: $output_video"
}

# Show usage
show_usage() {
    cat << EOF
Video Processor for OBS Recordings

Usage:
    $0 <command> [options]

Commands:
    trim              Trim video from start/end
    normalize         Normalize audio volume
    analyze           Analyze audio volume
    mix               Mix video with background music
    process           Run full processing pipeline
    help              Show this help message

Trim Usage:
    $0 trim <input_video> <output_video> <start_trim> <end_trim>
    Example: $0 trim input.mp4 output.mp4 00:00:10 00:00:05
    (Trims 10 seconds from start and 5 seconds from end)

Normalize Usage:
    $0 normalize <input_video> <output_video> [target_volume_dB]
    Example: $0 normalize input.mp4 output.mp4 -16
    (Normalizes to -16 dB, default for YouTube/podcasts)

Analyze Usage:
    $0 analyze <input_video>
    Example: $0 analyze input.mp4

Mix Usage:
    $0 mix <input_video> <background_music> <output_video> [music_volume] [video_audio_volume]
    Example: $0 mix input.mp4 music.mp3 output.mp4 0.3 1.0
    (music_volume=0.3 means 30% of original music volume)

Process Usage (Full Pipeline):
    $0 process <input_video> <background_music> <output_video> <start_trim> <end_trim> [target_volume] [music_volume]
    Example: $0 process recording.mp4 bg.mp3 final.mp4 00:00:05 00:00:10 -16 0.25

Time Format:
    Use HH:MM:SS format (e.g., 00:01:30) or seconds (e.g., 90)

EOF
}

# Main script logic
main() {
    check_dependencies

    if [[ $# -lt 1 ]]; then
        show_usage
        exit 1
    fi

    local command="$1"
    shift

    case "$command" in
        trim)
            if [[ $# -lt 4 ]]; then
                print_error "Trim requires 4 arguments: input_video output_video start_trim end_trim"
                exit 1
            fi
            trim_video "$1" "$2" "$3" "$4"
            ;;
        normalize)
            if [[ $# -lt 2 ]]; then
                print_error "Normalize requires at least 2 arguments: input_video output_video [target_volume]"
                exit 1
            fi
            normalize_audio "$1" "$2" "${3:--16}"
            ;;
        analyze)
            if [[ $# -lt 1 ]]; then
                print_error "Analyze requires 1 argument: input_video"
                exit 1
            fi
            analyze_audio_volume "$1"
            ;;
        mix)
            if [[ $# -lt 3 ]]; then
                print_error "Mix requires at least 3 arguments: input_video background_music output_video [music_volume] [video_audio_volume]"
                exit 1
            fi
            mix_with_background_music "$1" "$2" "$3" "${4:-0.3}" "${5:-1.0}"
            ;;
        process)
            if [[ $# -lt 5 ]]; then
                print_error "Process requires 5 arguments: input_video background_music output_video start_trim end_trim [target_volume] [music_volume]"
                exit 1
            fi
            process_video "$1" "$2" "$3" "$4" "$5" "${6:--16}" "${7:-0.3}"
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            print_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

main "$@"
