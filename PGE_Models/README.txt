This information is being made publicly available by the California Energy Commission (CEC) and Pacific Gas and Electric Company (PG&E) pursuant to a computer modeling project undertaken by PG&E and financed by the CEC under Contract # 500-11-018.  The project modeled the potential voltage impacts to postulated types of electric distribution circuits as hypothetical amounts of photovoltaic systems increase.  This work was conducted from October 2012 to March 2015.   Under the modeling activities for the project PG&E’s CYME-based feeder models were translated into GridLAB-D™ file format using an open-source Python scripting language.  This script is provided.  GridLAB-D primary and secondary models are also provided.  No private customer data is contained in the information being made available.  This information is being made available without any warranty of any kind.

Three sets of files are contained here:

1) Python Conversion Script – we developed a python script that was used to convert PG&E’s CYMDIST files to GridLAB-D.  This may not be usable directly but we thought that it may help others who are trying to convert CYMDIST data to GridLAB-D, at least it may give some clues.  

2) GLD Simulation Secondary – These are the GridLAB-D models of a typical secondary voltage system.

3) GLD Simulation Primary – This contains 12 GridLAB-D models, selected using k-means cluster analysis on PG&E’s 2,700 feeders, of primary distribution feeders from our CYMDIST data.  These could be considered representative of the different “types” of feeders on the PG&E system.

