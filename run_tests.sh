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

  echo "Expected output:           Temporary output:" | tee -a $log_file
  paste <(cat -n "$expected_output_file") <(cat -n "$temp_output_file") | while IFS=$'\t' read -r num1 line1 num2 line2
  do
    printf "%-30s %-30s\n" "$line1" "$line2" | tee -a $log_file
  done

  echo "=======================" >> $log_file

  # Clean up temporary files
  rm "$temp_output_file"
}

# Run all test cases
for (( i=0; i<${#input_files[@]}; i++ )); do
  run_test "${input_files[$i]}" "${output_files[$i]}"
done

echo "Test run complete. See $log_file for details."
