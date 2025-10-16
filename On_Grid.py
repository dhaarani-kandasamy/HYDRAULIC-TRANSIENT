import numpy as np
import plotly.graph_objs as go
from plotly.subplots import make_subplots
import os

# Simulation parameters
pv_capacity_kw = 2  # Increased PV capacity to 2 kW to allow excess energy
inverter_efficiency = 0.9  # 90% efficient inverter
time_steps = 24  # Simulating over 24 hours
time_interval = 1  # 1 hour time step

# Simulated solar irradiance over 24 hours (kW/m^2)
solar_irradiance = np.array([0, 0, 0, 0, 0.1, 0.3, 0.6, 0.8, 0.9, 0.85, 0.75, 0.5, 0.4, 0.3, 0.2, 0.1, 0, 0, 0, 0, 0, 0, 0, 0.85])

# PV system output (kW) assuming a constant PV efficiency (simplified)
pv_output = pv_capacity_kw * solar_irradiance

# Variable load demand (kW) defined by an array
load_demand = np.array([0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.2, 1.3, 1.4, 1.3, 1.1, 1.0, 0.9, 0.8, 0.7, 0.6, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2])

# Initialize arrays
energy_supplied = np.zeros(time_steps)
energy_to_grid = np.zeros(time_steps)
energy_from_grid = np.zeros(time_steps)

# Simulation loop
for t in range(time_steps):
    # Energy from PV after inverter losses
    energy_from_pv = pv_output[t] * inverter_efficiency

    # Net energy after meeting variable load demand
    net_energy = energy_from_pv - load_demand[t]

    if net_energy >= 0:
        # Excess energy fed to the grid
        energy_to_grid[t] = net_energy
        energy_supplied[t] = load_demand[t]
    else:
        # Deficit energy drawn from the grid
        energy_needed = -net_energy
        energy_from_grid[t] = energy_needed
        energy_supplied[t] = load_demand[t]

# Time for the x-axis
time = list(range(24))

# Create a subplot
fig = make_subplots(rows=4, cols=1, shared_xaxes=True, subplot_titles=("PV Output and Variable Load Demand", "Energy to Grid", "Energy from Grid", "Energy Supplied to Load"))

# PV Output and Variable Load Demand
fig.add_trace(go.Scatter(x=time, y=pv_output, mode='lines', name='PV Output (kW)'), row=1, col=1)
fig.add_trace(go.Scatter(x=time, y=load_demand, mode='lines', name='Variable Load Demand (kW)', line=dict(dash='dash')), row=1, col=1)

# Energy to Grid
fig.add_trace(go.Scatter(x=time, y=energy_to_grid, mode='lines', name='Energy to Grid (kW)'), row=2, col=1)

# Energy from Grid
fig.add_trace(go.Scatter(x=time, y=energy_from_grid, mode='lines', name='Energy from Grid (kW)'), row=3, col=1)

# Energy Supplied
fig.add_trace(go.Scatter(x=time, y=energy_supplied, mode='lines', name='Energy Supplied (kW)'), row=4, col=1)

# Update layout
fig.update_layout(height=1000, title_text="On-Grid Solar PV System with Variable Load Simulation")

# Show the plot
fig.show()

# Define the directory to save the files
output_dir = "D:/Python Files/LAB/"
os.makedirs(output_dir, exist_ok=True)  # Create the directory if it doesn't exist

# Save the figure as a PNG file in the specified directory
fig.write_image(os.path.join(output_dir, "solar_pv_simulation.png"))

# Save the figure as an HTML file in the specified directory
fig.write_html(os.path.join(output_dir, "solar_pv_simulation.html"))


print(f"Figure saved as {os.path.join(output_dir, 'solar_pv_simulation.png')} and {os.path.join(output_dir, 'solar_pv_simulation.html')}")
