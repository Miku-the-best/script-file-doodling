#!/bin/bash

# Check if both filename and source file are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <source_file> <input_file> <answers_file>"
    exit 1
fi

source_file=$1
input_file=$2
answers_file=$3
executable="program"

# Check if the source file exists
if [ ! -f "$source_file" ]; then
    echo "Error: '$source_file' not found."
    exit 1
fi

# Compile the C++ program
g++ -o "$executable" "$source_file"

# Check if compilation was successful
if [ $? -ne 0 ]; then
    echo "Compilation failed. Exiting."
    exit 1
fi

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: '$input_file' not found."
    exit 1
fi

# Check if the answers file exists
if [ ! -f "$answers_file" ]; then
    echo "Error: '$answers_file' not found."
    exit 1
fi

correct_count=0
total_count=0

# Read each line from the input file and pass it to the compiled program
while IFS= read -r line && IFS= read -r expected <&3; do
    echo "Enter a string: $line"
    output=$(echo "$line" | ./"$executable")
    if [ "$output" = "$expected" ]; then
        ((correct_count++))
        echo "Output: $output (Expected: $expected) - Correct"
    else
        echo "Output: $output (Expected: $expected) - Incorrect"
    fi
    ((total_count++))
done < "$input_file" 3< "$answers_file"

# Calculate percentage
percentage=$((correct_count * 100 / total_count))

echo "Number of correct matches: $correct_count"
echo "Number of incorrect matches: $((total_count - correct_count))"
echo "Percentage correct: $percentage%"

# Clean up the compiled executable
rm "$executable"
