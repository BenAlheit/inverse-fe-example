import os
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import scipy.optimize as op
from jinja2 import Template
import abaqus_input_file_expressions as ae
from pathlib import Path
import run_abaqus_standard_job as rj

# Constants
AMP_NAME = 'amp-1'
TIME_POINTS_NAME = 'time-points-1'
MATERIAL_NAME = 'soft-tissue'
G = 1
D = 1

# Read data
data = pd.read_csv('./test_data/uniaxial/fake-uniaxial-data.csv')


def write_input_file(material_func, material_func_params, directory):
    # Load input file template
    inp_template = Template(open('./block/uniaxial-tension.inp-tmp', 'r').read())
    inp_file_str = inp_template.render(
        amplitude=ae.amplitude(name=AMP_NAME, time=data['time (s)'].tolist(),
                               amp=(data['strain (mm/mm)'] / data['strain (mm/mm)'].iloc[-1]).tolist()),
        material_name=MATERIAL_NAME,
        material=material_func(MATERIAL_NAME, *material_func_params),
        time_points=ae.time_points(TIME_POINTS_NAME, points=data['time (s)']),
        step=ae.static_step(name='load', final_time=data['time (s)'].iloc[-1]),
        pull_bc=ae.displacement_bc(name='pull', set_name='pull', amplitude_name=AMP_NAME,
                                   x=data['strain (mm/mm)'].iloc[-1]),
        field_outputs=ae.minimal_field_output(time_points_name=TIME_POINTS_NAME)
    )
    Path(directory).mkdir(parents=True, exist_ok=True)
    open(f'{directory}/uniaxial.inp', 'w+').write(inp_file_str)


def unpack_nh(x):
    return x[0], 1 / (x[0] * 10)


def unpack_ogden(x):
    n = int(len(x) / 2)
    d = 1 / x[:n]
    return x[:n], x[n:], d


def objective_function(x, unpack_params, material_func, directory, plot_curve=False):
    params = unpack_params(x)
    write_input_file(material_func, params, directory)
    # Run abaqus simulation
    rj.run_abaqus_standard_sim(directory, 'uniaxial', overwrite_old=True)
    # Extract stress strain data from odb
    os.system(f'abaqus cae noGUI=./block/extract_data.py -- {directory} uniaxial')
    # Read in abaqus data
    aba_data = pd.read_csv(f'{directory}/uniaxial-tension-data.csv')

    if plot_curve:
        plot(directory, aba_data, data)
    # Return norm of difference in results
    return np.linalg.norm(aba_data['stress (MPa)'] - data['stress (MPa)'])


def plot(title, aba_data, data):
    aba_data['stress (MPa)'].plot(label='Abaqus')
    data['stress (MPa)'].plot(label='Data')
    plt.legend()
    plt.grid()
    plt.title(title)
    plt.show()


if __name__ == '__main__':

    res = op.minimize(fun=objective_function,
                      x0=np.array([4.67766444, 2., 3., 100]),
                      args=(unpack_ogden, ae.ogden_material, './block/ogden-fitting', True))
    print('Ogden optimized result')
    print(res)
    aba_data = pd.read_csv('./block/ogden-fitting/uniaxial-tension-data.csv')
    plot("Optimized Ogden", aba_data, data)

    res = op.minimize(fun=objective_function,
                      x0=np.array([G]),
                      args=(unpack_nh, ae.neo_hooke_material, './block/nh-fitting', False))

    print('Neo-Hookean optimized result')
    print(res)
    # G_opt = 5.47765411
    aba_data = pd.read_csv('./block/nh-fitting/uniaxial-tension-data.csv')
    plot("Optimized Neo-Hookean", aba_data, data)

