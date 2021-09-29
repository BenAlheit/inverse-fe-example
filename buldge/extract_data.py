from abaqus import *
from abaqusConstants import *
import __main__
# from helpful_functions import *
import numpy as np
# import read_odb_utils
import os
import subprocess
import section
import regionToolset
import displayGroupMdbToolset as dgm
import part
import material
import assembly
import step
import interaction
import load
import mesh
import optimization
import job
import sketch
import visualization
import xyPlot
import displayGroupOdbToolset as dgo
import connectorBehavior
# from model_creating_macros import *
# from post_processing_macros import *
# import scipy
import sys
# import matplotlib.pyplot as plt
import time
import os
# import csv
# t_h = 1.4 / 2.
# c_thick = 0.35

out_dir = sys.argv[-2]
job = sys.argv[-1]
print >> sys.__stdout__, os.getcwd()
os.chdir(out_dir)


def string_map(a_list):
    return map(lambda x: str(x), a_list)


step_name='inflate'


def extract_pressure_displacement_data():
    o = session.openOdb(name=job + '.odb', readOnly=False)
    n_frames = len(o.steps[step_name].frames)
    p = np.zeros(n_frames)
    d = np.zeros(n_frames)
    t = np.zeros(n_frames)
    disp_node = o.rootAssembly.nodeSets['CENTRE']

    # print >> sys.__stdout__, o.steps[step_name].frames[1].fieldOutputs['U'].getSubset(region=disp_node).values[0].data[2]

    for i_frame in range(n_frames):
        p[i_frame] = o.steps[step_name].frames[i_frame].fieldOutputs['P'].bulkDataBlocks[0].data.transpose().mean()
        # d[i_frame] = o.steps[step_name].frames[i_frame].fieldOutputs['U'].getSubset(region=disp_node).bulkDataBlocks[0].data.transpose().mean()
        d[i_frame] = o.steps[step_name].frames[i_frame].fieldOutputs['U'].getSubset(region=disp_node).values[0].data[2]
        t[i_frame] = o.steps[step_name].frames[i_frame].frameValue

    data = 'time (s),displacement (mm),pressure (MPa)\n'
    data += '\n'.join(string_map(np.array([t, d, p]).T.tolist())).replace('[', '').replace(']', '')
    open('bulge-data.csv', 'w+').write(data)
    # print >> sys.__stdout__, data



extract_pressure_displacement_data()
