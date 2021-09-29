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
data = pd.read_csv('./test_data/bulge/fake-bulge-data.csv')


def write_input_file(material_func, material_func_params, directory):
    # Load input file template
    inp_template = Template(open('./buldge/bulge.inp-tmp', 'r').read())
    inp_file_str = inp_template.render(
        material=material_func(MATERIAL_NAME, *material_func_params))
    Path(directory).mkdir(parents=True, exist_ok=True)
    open(f'{directory}/bulge.inp', 'w+').write(inp_file_str)


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
    rj.run_abaqus_standard_sim(directory, 'bulge', cpus=10, overwrite_old=True)
    # Extract stress strain data from odb
    os.system(f'abaqus cae noGUI=./buldge/extract_data.py -- {directory} bulge')
    # Read in abaqus data
    aba_data = pd.read_csv(f'{directory}/bulge-data.csv')

    if plot_curve:
        plot(directory, aba_data, data)
    # Return norm of difference in results
    return np.linalg.norm(aba_data['displacement (mm)'] - data['displacement (mm)'])


def plot(title, aba_data, data):
    aba_data['displacement (mm)'].plot(label='Abaqus')
    data['displacement (mm)'].plot(label='Data')
    plt.legend()
    plt.grid()
    plt.title(title)
    plt.show()


if __name__ == '__main__':

    res = op.minimize(fun=objective_function,
                      x0=np.array([4.67766444, 2., 3., 100]),
                      args=(unpack_ogden, ae.ogden_material, './buldge/ogden-fitting', False))
    print('Ogden optimized result')
    print(res)
    aba_data = pd.read_csv('./buldge/ogden-fitting/bulge-data.csv')
    plot("Optimized Ogden", aba_data, data)

    res = op.minimize(fun=objective_function,
                      x0=np.array([G]),
                      args=(unpack_nh, ae.neo_hooke_material, './buldge/nh-fitting', False))

    print('Neo-Hookean optimized result')
    print(res)
    # G_opt = 5.47765411
    aba_data = pd.read_csv('./buldge/nh-fitting/bulge-data.csv')
    plot("Optimized Neo-Hookean", aba_data, data)

