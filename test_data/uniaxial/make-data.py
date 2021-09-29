#%%
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
#%%
end_time = 6
end_strain = 0.24
n_points = 60
times = np.linspace(0, end_time, n_points)
noise = 0.01
#%%
strain = end_strain * times/times[-1] * np.random.normal(loc=1, scale=noise, size=n_points)
# plt.plot(times, strain)
# plt.show()
#%%

stress = np.exp(10*end_strain * times/times[-1]) * times/times[-1] * np.random.normal(loc=1, scale=noise, size=n_points)
# plt.plot(strain, stress)
# plt.show()
#%%

data = pd.DataFrame(data={
    'time (s)': times,
    'strain (mm/mm)': strain,
    'stress (MPa)': stress
})

data.set_index('time (s)', inplace=True)
data.to_csv('fake-uniaxial-data.csv')

a=0