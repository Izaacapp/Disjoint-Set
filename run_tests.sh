#!/bin/sh

# Compile the Java program
javac Main.java
if [ $? -ne 0 ]; then
  echo "Compilation failed"
  exit 1
fi

# Define an array of input files and their corresponding expected output files
input_files=("destroy_10.in" "destroy_sample_01.in" "destroy_sample_02.in")
output_files=("destroy_10.out" "destroy_sample_01.out" "destroy_sample_02.out")

# Function to run a test case
run_test() {
  input_file=$1
  expected_output_file=$2
  temp_output_file="${input_file}.temp.out"

  echo "Running test with input: $input_file"

  # Run the Java program with the input file
  java Main < "$input_file" > "$temp_output_file"
  if [ $? -ne 0 ]; then
    echo "Execution failed for input: $input_file"
    return 1
  fi

  # Compare the output with the expected output
  if diff -q "$temp_output_file" "$expected_output_file" > /dev/null; then
    echo "Test passed for input: $input_file"
  else
    echo "Test failed for input: $input_file"
    echo "Differences:"
    diff "$temp_output_file" "$expected_output_file"
  fi

  # Clean up temporary output file
  rm "$temp_output_file"
}

# Run all test cases
for (( i=1; i<=${#input_files[@]}; i++ )); do
  run_test "${input_files[$i-1]}" "${output_files[$i-1]}"
done
