#
# plot_results_data.py
# Description: Script for quick observation of scalar data stored in res/w1.dat
#              In this example it's used to plot circuit data such as voltage, current, etc
#              The script displays all available options and you can manually input
#              x-axis and y-axis values to be plot
#
# Author: Jonathan Velasco
#--------------------------------------------------------------------------------------


import matplotlib.pyplot as plt

def read_metadata_file(metadata_filename):
    column_mapping = {}
    
    with open(metadata_filename, 'r') as file:
        lines = file.readlines()
        
        for line in lines:
            if line.strip().startswith("Variables in columns of matrix:"):
                break
        
        # Now read the lines containing the column mapping
        for line in lines[lines.index(line) + 1:]:
            line = line.strip()
            if not line:
                continue
            parts = line.split(': ')
            if len(parts) == 3:
                col_index = int(parts[0].strip())
                variable_type = parts[1].strip()
                variable_name = parts[2].strip()
                column_mapping[variable_name] = col_index - 1  # Use zero-based index
    
    return column_mapping

def read_data_file(data_filename):
    data = []
    
    with open(data_filename, 'r') as file:
        for line in file:
            row = list(map(float, line.split()))
            data.append(row)
    
    return list(zip(*data))  # Transpose rows to columns

def plot_variables(data, column_mapping, x_variable, y_variables):
    if x_variable not in column_mapping:
        print(f"Variable '{x_variable}' not found in metadata.")
        return
    
    x_index = column_mapping[x_variable]
    
    for y_variable in y_variables:
        if y_variable in column_mapping:
            y_index = column_mapping[y_variable]
            plt.plot(data[x_index], data[y_index], marker='o', linestyle='-', label=y_variable)
        else:
            print(f"Variable '{y_variable}' not found in metadata.")
    
    plt.xlabel(x_variable)
    plt.ylabel("Values")
    plt.title(f"Variables vs {x_variable}")
    plt.legend()
    plt.grid(True)
    plt.show()

# Main script execution
metadata_filename = "res/w1.dat.names"  # Replace with your actual filename
data_filename = "res/w1.dat"  # Replace with your actual filename

# Reading files
column_mapping = read_metadata_file(metadata_filename)

# Print available variables
print("Available variables for plotting:")
for variable in column_mapping:
    print(variable)

data = read_data_file(data_filename)

# Example of usage:
x_variable = input("Enter the variable name for the x-axis: ")
y_variables = input("Enter the variable names for the y-axis (comma-separated): ").split(',')

# Trim any whitespace around variable names
y_variables = [y.strip() for y in y_variables]

plot_variables(data, column_mapping, x_variable, y_variables)

