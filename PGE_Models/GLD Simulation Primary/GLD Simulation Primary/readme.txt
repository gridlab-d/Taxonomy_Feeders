Steps to run GridLAB-D time series simulation:

1. start a command prompt
2. change working directory to a folder containing the feeder model on which simulation needs to be performed
3. Copy-paste CA-San_francisco.tmy2 in that folder
4. Run simulation by

>>gridlabd <feeder-name>_glmfile_ts.glm

5. For running different scenarios, uncomment from the following section as appropriate in <feeder-name>_glmfile_ts.glm

//*********************************************
// Cap, Reg, PV Objects
//*********************************************
#include "AL0001_glmfile_equip_manual.glm"
//#include "AL0001_glmfile_equip_volt.glm"
#include "AL0001_glmfile_PVend.glm"
//#include "AL0001_glmfile_PVcenter.glm"
//#include "AL0001_glmfile_PVdist.glm"
//#include "AL0001_glmfile_PVLargedist.glm"
//#include "AL0001_glmfile_PVend_smartinv.glm"
//#include "AL0001_glmfile_PVend_flicker.glm"