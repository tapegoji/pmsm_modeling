import matplotlib.pyplot as plt
import argparse

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

def plot_variables_in_subplots(data_list, column_mappings, file_labels, x_variable, y_variable_groups):
    num_subplots = len(y_variable_groups)
    
    fig, axes = plt.subplots(num_subplots, 1, figsize=(10, 6 * num_subplots))  # Dynamically adjust size based on number of subplots
    
    # If there's only one subplot, put it in a list to handle it uniformly
    if num_subplots == 1:
        axes = [axes]
    
    # Define different markers and line styles
    markers = ['o', 's', '^', 'D', 'v', 'P', '*']  # Cycle through these markers
    line_styles = ['-', '--', '-.', ':']  # Cycle through line styles
    
    for i, y_variable_set in enumerate(y_variable_groups):
        ax = axes[i]  # Current subplot
        
        for y_variable in y_variable_set:
            for idx, (data, column_mapping, label) in enumerate(zip(data_list, column_mappings, file_labels)):
                if x_variable not in column_mapping or y_variable not in column_mapping:
                    print(f"Variable '{x_variable}' or '{y_variable}' not found in metadata for file: {label}.")
                    continue
                
                x_index = column_mapping[x_variable]
                y_index = column_mapping[y_variable]
                
                # Cycle through markers and line styles based on the file index
                marker = markers[idx % len(markers)]
                line_style = line_styles[idx % len(line_styles)]
                
                ax.plot(data[x_index], data[y_index], marker=marker, linestyle=line_style, 
                        label=f"{label} - {y_variable}")
        
        ax.set_xlabel(x_variable)
        ax.set_ylabel("Values")
        ax.set_title(f"{', '.join(y_variable_set)} vs {x_variable}")
        ax.legend()
        ax.grid(True)
    
    plt.tight_layout()  # Adjust layout to prevent overlap
    plt.show()

def main():
    # Argument parsing
    parser = argparse.ArgumentParser(description="Plot simulation results.")
    parser.add_argument('source', choices=['current', 'voltage'], help="Type of source data to plot.")
    args = parser.parse_args()

    source_type = args.source

    # File paths and labels based on source type
    metadata_filenames = ["results_massive/w1.dat.names", "results_stranded/w1.dat.names"]  # Update as needed
    data_filenames = ["results_massive/w1.dat", "results_stranded/w1.dat"]  # Update as needed
    file_labels = ["Massive Results", "Stranded Results"]  # Labels for each dataset

    if source_type == 'current':
        y_variable_groups = [
            ["i_i1", "i_i2", "i_i3"],  # First subplot: currents
            ["v_i1", "v_i2", "v_i3"],   # Second subplot: voltages
            #["i_component(1)", "i_component(2)", "i_component(3)","i_component(4)","i_component(5)","i_component(6)"],   # Third subplot: currents in components
            #["v_component(1)", "v_component(2)", "v_component(3)","v_component(4)","v_component(5)","v_component(6)"]   # Fourth subplot: voltages in components
        ]
    elif source_type == 'voltage':
        y_variable_groups = [
            ["i_v1", "i_v2", "i_v3"],  # First subplot: currents
            ["v_v1", "v_v2", "v_v3"],   # Second subplot: voltages
            #["i_component(1)", "i_component(2)", "i_component(3)","i_component(4)","i_component(5)","i_component(6)"],   # Third subplot: currents in components
            #["v_component(1)", "v_component(2)", "v_component(3)","v_component(4)","v_component(5)","v_component(6)"]   # Fourth subplot: voltages in components
        ]

    # Hardcoded x_variable
    x_variable = "time"

    # Reading files
    column_mappings = [read_metadata_file(metadata_filename) for metadata_filename in metadata_filenames]
    data_list = [read_data_file(data_filename) for data_filename in data_filenames]

    # Plot the variables in subplots
    plot_variables_in_subplots(data_list, column_mappings, file_labels, x_variable, y_variable_groups)

if __name__ == "__main__":
    main()

