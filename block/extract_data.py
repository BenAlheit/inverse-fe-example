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


def extract_pressure_displacement_data():
    o = session.openOdb(name=job + '.odb', readOnly=False)
    n_frames = len(o.steps['load'].frames)
    s = np.zeros(n_frames)
    eps = np.zeros(n_frames)
    t = np.zeros(n_frames)
    for i_frame in range(n_frames):
        s[i_frame] = o.steps['load'].frames[i_frame].fieldOutputs['S'].bulkDataBlocks[0].data.transpose()[0,:].mean()
        eps[i_frame] = np.exp(o.steps['load'].frames[i_frame].fieldOutputs['LE'].bulkDataBlocks[0].data.transpose()[0,:].mean())-1
        t[i_frame] = o.steps['load'].frames[i_frame].frameValue

    data = 'time (s),strain (mm/mm),stress (MPa)\n'
    data += '\n'.join(string_map(np.array([t, eps, s]).T.tolist())).replace('[', '').replace(']', '')
    open('uniaxial-tension-data.csv', 'w+').write(data)
    # print >> sys.__stdout__, data



extract_pressure_displacement_data()

# o = session.openOdb(name=out_dir+'/'+job+'.odb', readOnly=False)
# disp_node = o.rootAssembly.instances['MERGED-PARTS-1'].nodeSets['DISP-NODE']
#
#
# print >> sys.__stdout__, o.steps['load'].frames[1].fieldOutputs['S'].bulkDataBlocks[0].data.transpose()[0, :].mean()
# print >> sys.__stdout__, o.steps['load'].frames[1].fieldOutputs['LE'].bulkDataBlocks[0].data.transpose()[0, :].mean()
# print >> sys.__stdout__, o.steps['load'].frames[1].frameValue
# print >> sys.__stdout__, dir(o.steps['load'].frames[1].fieldOutputs['S'].bulkDataBlocks[0].data)
# historyRegions['Assembly ASSEMBLY'].historyOutputs

