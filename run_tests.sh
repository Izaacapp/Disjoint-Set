#!/bin/bash

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
printf "%-50s | %-50s\n" "Temporary Output" "Expected Output" >> $log_file
echo "=====================================================================================================================" >> $log_file

# Function to run a test case
run_test() {
  input_file=$1
  expected_output_file=$2
  temp_output_file="${input_file}.temp.out"
  temp_trimmed_output_file="${input_file}.trimmed.temp.out"
  expected_trimmed_output_file="${expected_output_file}.trimmed"

  echo "Running test with input: $input_file" | tee -a $log_file

  # Run the Java program with the input file
  java Main < "$input_file" > "$temp_output_file"
  if [ $? -ne 0 ]; then
    echo "Execution failed for input: $input_file" | tee -a $log_file
    return 1
  fi

  # Trim trailing whitespaces from the temporary output and expected output
  tr -d '[:space:]' < "$temp_output_file" > "$temp_trimmed_output_file"
  tr -d '[:space:]' < "$expected_output_file" > "$expected_trimmed_output_file"

  # Compare the trimmed outputs
  if diff -q "$temp_trimmed_output_file" "$expected_trimmed_output_file" > /dev/null; then
    echo "Test passed for input: $input_file" | tee -a $log_file
  else
    echo "Test failed for input: $input_file" | tee -a $log_file
    echo "Differences:" | tee -a $log_file
    diff "$temp_trimmed_output_file" "$expected_trimmed_output_file" | tee -a $log_file
  fi

  # Append the temporary and expected output to the log file for review
  echo "Temporary output vs Expected output:" >> $log_file

  # Read the files line by line and print them side by side
  paste <(cat $temp_output_file) <(cat $expected_output_file) | awk -F '\t' '{printf "%-50s | %-50s\n", $1, $2}' >> $log_file

  echo "=====================================================================================================================" >> $log_file

  # Clean up temporary files
  rm "$temp_output_file" "$temp_trimmed_output_file" "$expected_trimmed_output_file"
}

# Run all test cases
for (( i=0; i<${#input_files[@]}; i++ )); do
  run_test "${input_files[$i]}" "${output_files[$i]}"
done

echo "Test run complete. See $log_file for details."
