import numpy as np


def string_map(a_list):
    return map(lambda x: str(x), a_list)


def neo_hooke_material(name: str, G: float, D: float):
    return f"""*Material, name={name}
*Hyperelastic, neo hooke
{G},{D}"""


def ogden_material(name: str, mu: [float], alpha: [float], D: [float]):
    if len(mu) != len(alpha) or len(alpha) != len(D):
        raise Exception("The length of mu, alpha, and D must be the same.")

    n = len(mu)

    table = ', '.join(string_map(np.array([mu, alpha]).T.tolist())).replace('[', '').replace(']', '')
    table += ', ' + ', '.join(string_map(D))
    return f"""*Material, name={name}
*Hyperelastic, n={n}, ogden
{table}"""


def time_points(name: str, points: list):
    table = ", \n".join(string_map(points))
    return f"""*Time Points, name={name}
{table}"""


def amplitude(name: str, time: list, amp: list):
    table = '\n'.join(string_map(np.array([time, amp]).T.tolist())).replace('[', '').replace(']', ',')
    return f"""*Amplitude, name={name}
{table}"""


def displacement_bc(name: str, set_name: str, amplitude_name: str, x=None, y=None, z=None):
    if x is None and y is None and z is None:
        raise Exception('Must set at least one value between x, y, and z!')
    vals = [x, y, z]
    return f"""** Name: {name} Type: Displacement/Rotation
*Boundary, amplitude={amplitude_name}\n""" + \
           '\n'.join([f'{set_name}, {i+1}, {i+1}, {vals[i]}' for i in range(3) if vals[i] is not None])


def minimal_field_output(time_points_name: str):
    return f"""** FIELD OUTPUT: F-Output-1
** 
*Output, field, time points={time_points_name}
*Node Output
CF, RF, U
*Element Output, directions=YES
E, S"""


def static_step(name, final_time: float, inc=1000, nlgeom='YES'):
    return f"""** STEP: {name}
** 
*Step, name={name}, nlgeom={nlgeom}, inc={inc}
*Static
{final_time}, {final_time}, {final_time/inc}, {final_time}
**"""
