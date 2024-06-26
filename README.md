## Overview
This project is for Assignment 3 of COP 3503C. The assignment involves using disjoint set data structures to solve the problem of reducing network connectivity by destroying connections.

## Files Included
- **Main.java**: The main Java program file containing the implementation of the solution.
- **destroy_10.in**: Input file for test case 1.
- **destroy_10.out**: Expected output file for test case 1.
- **destroy_sample_01.in**: Input file for test case 2.
- **destroy_sample_01.out**: Expected output file for test case 2.
- **destroy_sample_02.in**: Input file for test case 3.
- **destroy_sample_02.out**: Expected output file for test case 3.
- **run_tests.sh**: Shell script to compile and run the tests.
- **test_results.log**: Log file to store the results of the test runs.
- **CS2 PA3 SUM 24.pdf**: Assignment description and requirements.
- **Plambeck_testStrategy.txt**: Testing strategy document.
- **PA3 more hints.png**: Additional hints for the assignment.

## Compilation and Execution
To compile and run the program along with the tests, follow these steps:

1. **Compile the Java Program:**
    ```bash
    javac Main.java
    ```

2. **Run the Tests:**
    ```bash
    ./run_tests.sh
    ```

This script will compile the Java program, run it against the provided input files, and compare the outputs with the expected results. The results of the tests will be logged in `test_results.log`.

## Sample Input and Output
### Test Case 1
**Input:**
```
3 3 3
1 2
1 3
2 3
3
1
2
```

**Expected Output:**
```
9
9
5
3
```

### Running the Tests
To run the tests, execute the `run_tests.sh` script as described above. This will automate the testing process and log the results for each test case.

## Testing Strategy
The testing strategy is outlined in the `Plambeck_testStrategy.txt` file. It includes unit tests, integration tests, system tests, and performance tests to ensure the robustness and correctness of the program.

## Conclusion
This project uses disjoint set data structures to solve the problem of reducing network connectivity. The provided files and scripts ensure that the program is tested thoroughly to meet the assignment requirements.

