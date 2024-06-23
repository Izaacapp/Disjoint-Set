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

# Log file to store the results
log_file="test_results.log"

# Initialize the log file
echo "Test Results - $(date)" > $log_file
echo "=======================" >> $log_file

# Function to run a test case
run_test() {
  input_file=$1
  expected_output_file=$2
  temp_output_file="${input_file}.temp.out"

  echo "Running test with input: $input_file" | tee -a $log_file

  # Run the Java program with the input file
  java Main < "$input_file" > "$temp_output_file"
  if [ $? -ne 0 ]; then
    echo "Execution failed for input: $input_file" | tee -a $log_file
    return 1
  fi

  # Compare the outputs and print side-by-side
  if diff -q "$temp_output_file" "$expected_output_file" > /dev/null; then
    echo "Test passed for input: $input_file" | tee -a $log_file
  else
    echo "Test failed for input: $input_file" | tee -a $log_file
    echo "Expected output:           Temporary output:" | tee -a $log_file

    # Ensure the files have the same number of lines by padding with empty lines
    lines_expected=$(wc -l < "$expected_output_file")
    lines_temp=$(wc -l < "$temp_output_file")
    max_lines=$((lines_expected > lines_temp ? lines_expected : lines_temp))

    awk 'NR<=ARGC-1 {a[NR]=$0} NR<=ARGC-2 {b[NR]=$0} END { for (i=1; i<=ARGV[3]; i++) printf "%-30s %-30s\n", a[i], b[i] }' "$expected_output_file" "$temp_output_file" "$max_lines" >> $log_file
  fi

  echo "=======================" >> $log_file

  # Clean up temporary files
  rm "$temp_output_file"
}

# Run all test cases
for (( i=0; i<${#input_files[@]}; i++ )); do
  run_test "${input_files[$i]}" "${output_files[$i]}"
done

echo "Test run complete. See $log_file for details."
