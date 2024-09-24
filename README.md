# conway-verilog

Conway's Game of Life implemented on Intel Quartus using System Verilog. The implementation includes an extension that utilizes two seven-segment displays on the FPGA to track the number of blinker patterns detected during gameplay, with a count limit of 15 (4-bit system) before resetting to 0

## Overview

- **Platform:** Intel Quartus Prime
- **Language:** System Verilog
- **Purpose:** Simulates Conway’s Game of Life on an FPGA, with functionality to detect and count blinker patterns using dedicated hardware resources

## Key Features

- **Grid Simulation:** Implements Conway’s Game of Life rules for cellular automata on a grid using LEDs to display active cells
- **Blinker Detection:** Counts up to 15 blinker patterns, updating the count on seven-segment displays
- **User Interaction:** Uses switches and buttons for game control, including start/pause and cell state toggling

## Folder Structure

- `/root`
    - Contains primary project files and configurations
    - `/src`
        - Includes all the System Verilog (`.sv`) module files
        - `/pkgs`: Archived module files from prior class labs, not used in the current project
- `/led_driver` and `/led_driver-helper`
    - Instructor-provided modules showcasing LED board and GPIO interaction
- `project-report.pdf`: Project write-up which is private from public use
- `block-diagram.PNG`: Block diagram showcasing the interfacing between the 8 modules

## Modules Overview

- **`DE1_SoC.sv`**: Main module integrating all submodules and handling overall system control
- **`grid.sv`**: Manages the game grid logic and updates cell states based on Conway’s rules
- **`controlUnit.sv`**: Handles user inputs and control signals for game operations
- **`LEDDriver.sv`**: Interfaces with the LED display extension board to visualize active cells
- **`clock_divider.sv`**: Divides the system clock to appropriate frequencies for game timing
- **`patternCounterDisplay.sv`**: Detects and counts blinker patterns, displaying the count on seven-segment displays
- **`userInput.sv`**: Manages input signals from switches and buttons on the FPGA
- **`updateLogic.sv`**: Executes the state update logic for each cell on the grid per game tick

## Resources Utilization

- **Combinational ALUTs**: 2,543
- **Dedicated Logic Registers**: 856
- **Block Memory Bits**: 0
- **DSP Blocks**: 0
- **Pins**: 103

## Additional Details

For more technical insights, module screenshots, and design details, refer to the project report and individual `.pdf` files in the repo

## How to Use

1. Set up the FPGA board and connect the LED expansion module
2. Load the project files into Intel Quartus Prime and compile
3. Use the provided switches and buttons to control game states and interact with the simulation

## Citations

- Conway's Game of Life information and simulation tools: [Wikipedia](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life)
- Test case references and online resources are listed in the project report (not in repo)
