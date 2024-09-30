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

def plot_variables_from_multiple_files(data_list, column_mappings, file_labels, x_variable, y_variables):
    plt.figure(figsize=(10, 6))
    
    # Define different markers and line styles
    markers = ['o', 's', '^', 'D', 'v', 'P', '*']  # Cycle through these markers
    line_styles = ['-', '--', '-.', ':']  # Cycle through line styles
    
    # Ensure the variable exists in all files
    for y_variable in y_variables:
        for idx, (data, column_mapping, label) in enumerate(zip(data_list, column_mappings, file_labels)):
            if x_variable not in column_mapping or y_variable not in column_mapping:
                print(f"Variable '{x_variable}' or '{y_variable}' not found in metadata for file: {label}.")
                continue
            
            x_index = column_mapping[x_variable]
            y_index = column_mapping[y_variable]
            
            # Cycle through markers and line styles based on the file index
            marker = markers[idx % len(markers)]
            line_style = line_styles[idx % len(line_styles)]
            
            plt.plot(data[x_index], data[y_index], marker=marker, linestyle=line_style, 
                     label=f"{label} - {y_variable}")
    
    plt.xlabel(x_variable)
    plt.ylabel("Values")
    plt.title(f"Variables vs {x_variable} from Multiple Files")
    plt.legend()
    plt.grid(True)
    plt.show()

# Main script execution

metadata_filenames = ["results_stranded/w1.dat.names"]  # Add more filenames here
data_filenames = ["results_stranded/w1.dat"]  # Add more filenames here
file_labels = ["Stranded Results"]  # Labels for each dataset

# Reading files
column_mappings = [read_metadata_file(metadata_filename) for metadata_filename in metadata_filenames]
data_list = [read_data_file(data_filename) for data_filename in data_filenames]

# Print available variables for the first file
print("Available variables for plotting (based on first file):")
for variable in column_mappings[0]:
    print(variable)

# Example of usage:
#x_variable = input("Enter the variable name for the x-axis: ")
x_variable = "time"
y_variables = input("Enter the variable names for the y-axis (comma-separated): ").split(',')

# Trim any whitespace around variable names
y_variables = [y.strip() for y in y_variables]

# Plot the variables from multiple files
plot_variables_from_multiple_files(data_list, column_mappings, file_labels, x_variable, y_variables)

