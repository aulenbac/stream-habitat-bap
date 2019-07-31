#!/usr/bin/env python
# coding: utf-8

# In[65]:


import os
import folium
import pandas as pd
from folium.plugins import MarkerCluster


# In[66]:



os.chdir('C:/Users/rscully/Documents/Projects/Habitat Data Sharing/Detail/Code/tributary-habitat-data-sharing-/Data')
os.getcwd()

#import pandas as pd 
data = pd.read_csv('All_data.csv')
data = data.dropna() 

os.chdir('C:/Users/rscully/Documents/Projects/Habitat Data Sharing/Detail/Code/tributary-habitat-data-sharing-/Map')


# In[67]:


m = folium.Map(location=[data.iloc[0]['BRLat'], data.iloc[0]['BRLong']], zoom_start=3)

cluster = folium.plugins.MarkerCluster().add_to(m)
#for i in range(1,len(data)):
 #   folium.Marker(location=[data.iloc[i]['BRLat'], data.iloc[i]['BRLong']], popup=data.iloc[i]['Program']).add_to(cluster)
    
for i in range(0,100):
    folium.Marker(location=[data.iloc[i]['BRLat'], data.iloc[i]['BRLong']], popup=str(data.iloc[i]['Program'])).add_to(cluster)

    m.save('cluster_color.html')


# In[68]:


m = folium.Map(location=[data.iloc[0]['BRLat'], data.iloc[0]['BRLong']], zoom_start=3,    tiles = 'Stamen Terrain')

cluster = folium.plugins.MarkerCluster().add_to(m)
#for i in range(1,len(data)):
 #   folium.Marker(location=[data.iloc[i]['BRLat'], data.iloc[i]['BRLong']], popup=data.iloc[i]['Program']).add_to(cluster)
    
for i in range(0,len(data)):
    if data.iloc[i]['Program']=="BLM": 
        icon= folium.Icon(color='green')
        folium.Marker(location=[data.iloc[i]['BRLat'], data.iloc[i]['BRLong']], 
                      popup=str(data.iloc[i]['Program']), icon=folium.Icon(color='green')).add_to(cluster)
    elif data.iloc[i]['Program']=="PIBO": 
        icon= folium.Icon(color='red')
        folium.Marker(location=[data.iloc[i]['BRLat'], data.iloc[i]['BRLong']], 
                      popup=str(data.iloc[i]['Program']), icon=folium.Icon(color='red')).add_to(cluster)
    
m.save('map_cluster_color.html')


# In[69]:


m = folium.Map(location=[data.iloc[0]['BRLat'], data.iloc[0]['BRLong']], zoom_start=3)

cluster = folium.plugins.MarkerCluster().add_to(m)
#for i in range(1,len(data)):
 #   folium.Marker(location=[data.iloc[i]['BRLat'], data.iloc[i]['BRLong']], popup=data.iloc[i]['Program']).add_to(cluster)
    
for i in range(0,2000):
    if data.iloc[i]['Program']=="BLM": 
        icon= folium.Icon(color='green')
        folium.Marker(location=[data.iloc[i]['BRLat'], data.iloc[i]['BRLong']], 
                      popup=str(data.iloc[i]['Program']), icon=folium.Icon(color='green')).add_to(m)
    elif data.iloc[i]['Program']=="PIBO": 
        icon= folium.Icon(color='red')
        folium.Marker(location=[data.iloc[i]['BRLat'], data.iloc[i]['BRLong']], 
                      popup=str(data.iloc[i]['Program']), icon=folium.Icon(color='red')).add_to(m)
    
m.save('map_colors.html')


# In[70]:


get_ipython().run_line_magic('pwd', '')


# In[ ]:




