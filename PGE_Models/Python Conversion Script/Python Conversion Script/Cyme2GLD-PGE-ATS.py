#!/usr/bin/env python
#*************************************
# xml_parse12.py
#
# this program creates a GLM file
# using data from cyme xml file
# plots the network as a tree
# V Donde 09222014 last edit

#*************************************
#import modules
import csv 
import math
import xml.etree.ElementTree as ET
import networkx as nx
import pygraphviz as pgv
import matplotlib.pyplot as plt

# for debudding
import pdb
pdb.set_trace()
#**************************************

#Subroutines
#*********************************************
#create a OH Line conductor object
#*********************************************
def CreateOHConductor(f,Name,resistance,GMR,OutsideDiameter):
	f.write("// "+Name+"\n")
	f.write("object overhead_line_conductor {\n")
	f.write("	name "+Name+";\n")
	f.write("	resistance "+str(resistance)+";\n")
	f.write("	geometric_mean_radius "+str(GMR)+";\n")
	f.write("	diameter "+str(OutsideDiameter)+";\n")
	f.write("}\n\n")
	return


#*********************************************
#create a UG Line conductor object
#*********************************************
def CreateUGConductor(f,Name,outer_diameter,conductor_gmr,conductor_diameter,conductor_resistance,neutral_gmr,neutral_resistance,neutral_diameter,neutral_strands,shield_gmr,shield_resistance):
	f.write("// "+Name+"\n")
	f.write("object underground_line_conductor {\n")
	f.write("	name "+Name+";\n")
	if outer_diameter != '': f.write("	outer_diameter "+str(outer_diameter)+";\n")
	if conductor_gmr != '': f.write("	conductor_gmr "+str(conductor_gmr)+";\n")
	if conductor_diameter != '': f.write("	conductor_diameter "+str(conductor_diameter)+";\n")
	if conductor_resistance != '': f.write("	conductor_resistance "+str(conductor_resistance)+";\n")
	if neutral_gmr != '': f.write("	neutral_gmr "+str(neutral_gmr)+";\n")
	if neutral_resistance != '': f.write("	neutral_resistance "+str(neutral_resistance)+";\n")
	if neutral_diameter != '': f.write("	neutral_diameter "+str(neutral_diameter)+";\n")
	if neutral_strands != '': f.write("	neutral_strands "+str(neutral_strands)+";\n")
	if shield_gmr != '': f.write("	shield_gmr "+str(shield_gmr)+";\n")
	if shield_resistance != '': f.write("	shield_resistance "+str(shield_resistance)+";\n")
	f.write("}\n\n")
	return

#*********************************************
#create a line spacing object
#*********************************************
def CreateLineSpacing(f,Name,AB,BC,AC,AN,BN,CN,AE,BE,CE,NE):
	f.write("// "+Name+"\n")
	f.write("object line_spacing {\n")
	f.write("	name "+Name+";\n")
	f.write("	distance_AB "+str(AB)+";\n")
	f.write("	distance_BC "+str(BC)+";\n")
	f.write("	distance_AC "+str(AC)+";\n")
	if AN != '': f.write("	distance_AN "+str(AN)+";\n")
	if BN != '': f.write("	distance_BN "+str(BN)+";\n")
	if CN != '': f.write("	distance_CN "+str(CN)+";\n")
	if AE != '': f.write("	distance_AE "+str(AE)+";\n")
	if BE != '': f.write("	distance_BE "+str(BE)+";\n")
	if CE != '': f.write("	distance_CE "+str(CE)+";\n")
	if NE != '': f.write("	distance_NE "+str(NE)+";\n")
	f.write("}\n\n")
	return

#*********************************************
#create a Line config object
#*********************************************
def CreateLineConfig(f,Name,CondA,CondB,CondC,CondN,LineSpacing):
	f.write("// "+Name+"\n")
	f.write("object line_configuration {\n")
	f.write("	name "+Name+";\n")
	f.write("	conductor_A "+CondA+";\n")
	f.write("	conductor_B "+CondB+";\n")
	f.write("	conductor_C "+CondC+";\n")
        if CondN != '':
            f.write("	conductor_N "+CondN+";\n")
	f.write("	spacing "+LineSpacing+";\n")
	f.write("}\n\n")
	return


#*********************************************
#create a Line config object for user-defined impedances
#*********************************************
def CreateLineConfig_z(f,Name,R_self,X_self,R_mutual,X_mutual):
	f.write("// "+Name+"\n")
	f.write("object line_configuration {\n")
	f.write("	name "+Name+";\n")
	f.write("	z11 "+R_self+"+"+X_self+"j;\n")
	f.write("	z12 "+R_mutual+"+"+X_mutual+"j;\n")
	f.write("	z13 "+R_mutual+"+"+X_mutual+"j;\n")
	f.write("	z21 "+R_mutual+"+"+X_mutual+"j;\n")
	f.write("	z22 "+R_self+"+"+X_self+"j;\n")
	f.write("	z23 "+R_mutual+"+"+X_mutual+"j;\n")
	f.write("	z31 "+R_mutual+"+"+X_mutual+"j;\n")
	f.write("	z32 "+R_mutual+"+"+X_mutual+"j;\n")
	f.write("	z33 "+R_self+"+"+X_self+"j;\n")
	f.write("}\n\n")
	return



#*********************************************
#create node objects
#*********************************************
def CreateNode(f,Name,NomV,BusType,phase):
	f.write("object node {\n")
	f.write("	name "+Name+";\n")
	f.write("	nominal_voltage "+str(NomV)+";\n")
	f.write("	phases "+phase+";\n")
	if BusType == 'S':
	    f.write("	bustype SWING;\n")

	f.write("}\n\n")

	return


#*********************************************
#create line object
#*********************************************
def CreateLine(f,LineType,Name,phase,length,FromNode,ToNode,Config):
        if LineType in ("OverheadLine", "OverheadByPhase", "OverheadLineUnbalanced"):
	    f.write("object overhead_line {\n")
	    f.write("	name "+Name+";\n")
	    f.write("	phases "+phase+";\n")
	    f.write("	length "+str(length)+" ft;\n")
	    f.write("	from "+FromNode+";\n")
	    f.write("	to "+ToNode+";\n")
	    f.write("	configuration "+Config+";\n")
	    f.write("}\n\n")
        elif LineType == "Underground":
	    f.write("object underground_line {\n")
	    f.write("	name "+Name+";\n")
	    f.write("	phases "+phase+";\n")
	    f.write("	length "+str(length)+" ft;\n")
	    f.write("	from "+FromNode+";\n")
	    f.write("	to "+ToNode+";\n")
	    f.write("	configuration "+Config+";\n")
	    f.write("}\n\n")

	return


#*********************************************
#create switch object
#*********************************************
def CreateSwitch(f,Name,phase,FromNode,ToNode,status):
	f.write("object switch {\n")
	f.write("	name "+Name+";\n")
	f.write("	phases "+phase+";\n")
	f.write("	from "+FromNode+";\n")
	f.write("	to "+ToNode+";\n")
	f.write("	status "+status+";\n")
	f.write("}\n\n")
	return


#*********************************************
#create capacitor object
#*********************************************
def CreateCapacitor(f,Name,phase,PhasesConnected,ParticipatingPhase,FromNodeID,CapControl,voltage_set_high,voltage_set_low,capacitor_A,capacitor_B,capacitor_C,control_level,time_delay,dwell_time,switchA,switchB,switchC,nominal_voltage):
	f.write("object capacitor {\n")
	f.write("	name "+Name+";\n")
	f.write("	phases "+phase+";\n")
	f.write("	pt_phase "+ParticipatingPhase+";\n")
	f.write("	parent "+FromNodeID+";\n")
	f.write("	phases_connected "+PhasesConnected+";\n")
	f.write("	control "+CapControl+";\n")
	f.write("	voltage_set_high "+voltage_set_high+";\n")
	f.write("	voltage_set_low "+voltage_set_low+";\n")
	f.write("	capacitor_A "+str(capacitor_A)+";\n")
	f.write("	capacitor_B "+str(capacitor_B)+";\n")
	f.write("	capacitor_C "+str(capacitor_C)+";\n")
	f.write("	control_level "+control_level+";\n")
	f.write("	time_delay "+time_delay+";\n")
	f.write("	dwell_time "+dwell_time+";\n")
	f.write("	switchA "+switchA+";\n")
	f.write("	switchB "+switchB+";\n")
	f.write("	switchC "+switchC+";\n")
	f.write("	nominal_voltage "+str(nominal_voltage)+";\n")
	f.write("}\n\n")
	return

#*********************************************
#create solar object
#*********************************************
def CreateSolar(f,SolarID,InverterID,generator_mode,generator_status,panel_type,solar_efficiency,solar_area):
	f.write("object solar {\n")
	f.write("	name "+SolarID+";\n")
	f.write("	parent "+InverterID+";\n")
	f.write("	generator_mode "+generator_mode+";\n")
	f.write("	generator_status "+generator_status+";\n")
	f.write("	panel_type "+panel_type+";\n")
	f.write("	efficiency "+str(solar_efficiency)+";\n")
	f.write("	area "+str(solar_area)+";\n")
	f.write("}\n\n")
	return


#*********************************************
#create inverter object
#*********************************************
def CreateInverter(f,InverterID,InverterNodeID,InverterPhase,inverter_mode,generator_status,inverter_type,power_factor,rated_power,inverter_efficiency):
	f.write("object inverter {\n")
	f.write("	name "+InverterID+";\n")
	f.write("	parent "+InverterNodeID+";\n")
	f.write("	phases "+InverterPhase+";\n")
	f.write("	generator_mode "+inverter_mode+";\n")
	f.write("	generator_status "+generator_status+";\n")
	f.write("	inverter_type "+inverter_type+";\n")
	f.write("	power_factor "+str(power_factor)+";\n")
	f.write("	rated_power "+str(rated_power)+";\n")
	f.write("	inverter_efficiency "+str(inverter_efficiency)+";\n")
	f.write("}\n\n")
	return

#*********************************************
#create triplex meter object
#*********************************************
def CreateTriplexMeter(f,InverterNodeID,InverterPhase,sec_voltage):
	f.write("object triplex_meter {\n")
	f.write("	name "+InverterNodeID+";\n")
	f.write("	phases "+InverterPhase+";\n")
	f.write("	nominal_voltage "+str(sec_voltage)+";\n")
	f.write("}\n\n")
	return

#*********************************************
#create transformer object
#*********************************************
def CreateTransformer(f,XfrmID,InverterPhase,FromNodeID,InverterNodeID,Xfrm_config):
	f.write("object transformer {\n")
	f.write("	name "+XfrmID+";\n")
	f.write("	phases "+InverterPhase+";\n")
	f.write("	from "+FromNodeID+";\n")
	f.write("	to "+InverterNodeID+";\n")
	f.write("	configuration "+Xfrm_config+";\n")
	f.write("}\n\n")
	return

#*********************************************
#create transformer config object
#*********************************************
def CreateTransformeConfig(f,Xfrm_config,Xfrm_connect_type,Xfrm_install_type,Xfrm_power_rating,pri_voltage,sec_voltage,Xfrm_resistance,Xfrm_reactance):
	f.write("object transformer_configuration {\n")
	f.write("	name "+Xfrm_config+";\n")
	f.write("	connect_type "+Xfrm_connect_type+";\n")
	f.write("	install_type "+Xfrm_install_type+";\n")
	f.write("	power_rating "+str(Xfrm_power_rating)+";\n")
	f.write("	primary_voltage "+str(pri_voltage)+";\n")
	f.write("	secondary_voltage "+str(sec_voltage)+";\n")
	f.write("	resistance "+str(Xfrm_resistance)+";\n")
	f.write("	reactance "+str(Xfrm_reactance)+";\n")
	f.write("}\n\n")
	return

#PVTable[PVID] = [SolarID,InverterID,generator_mode,generator_status,panel_type,solar_efficiency,solar_area,InverterNodeID,InverterPhase,inverter_mode,inverter_type,power_factor,rated_power,inverter_efficiency,FromNodeID,pri_voltage,sec_voltage,XfrmID,Xfrm_config,Xfrm_connect_type,Xfrm_install_type,Xfrm_power_rating,Xfrm_resistance,Xfrm_reactance]



#*********************************************
#create load objects
#*********************************************
def CreateLoad(f,Name,NomV,phase,PA,QA,PB,QB,PC,QC):
	f.write("object load {\n")
	f.write("	name "+Name+";\n")
	f.write("	phases "+phase+";\n")
	f.write("	nominal_voltage "+str(NomV)+";\n")
	if load_shape == 1:
		f.write("	constant_power_A_real load_shape_A*"+str(PA)+";\n")
		f.write("	constant_power_B_real load_shape_B*"+str(PB)+";\n")
		f.write("	constant_power_C_real load_shape_C*"+str(PC)+";\n")
		f.write("	constant_power_A_reac load_shape_A*"+str(QA)+";\n")
		f.write("	constant_power_B_reac load_shape_B*"+str(QB)+";\n")
		f.write("	constant_power_C_reac load_shape_C*"+str(QC)+";\n")
	else:
		f.write("	constant_power_A_real "+str(PA)+";\n")
		f.write("	constant_power_B_real "+str(PB)+";\n")
		f.write("	constant_power_C_real "+str(PC)+";\n")
		f.write("	constant_power_A_reac "+str(QA)+";\n")
		f.write("	constant_power_B_reac "+str(QB)+";\n")
		f.write("	constant_power_C_reac "+str(QC)+";\n")

	f.write("}\n\n")

	return


#*********************************************
#create voltdump objects
#*********************************************
def CreateVoltdump(f,fileName,voltType):
	f.write("object voltdump {\n")
	f.write("	filename "+fileName+";\n")
	f.write("	mode "+voltType+";\n")
	f.write("}\n\n")
	return


#******************************************
#create voltdump objects
#*********************************************
def CreateCurrdump(f,fileName,currType):
	f.write("object currdump {\n")
	f.write("	filename "+fileName+";\n")
	f.write("	mode "+currType+";\n")
	f.write("}\n\n")
	return


#*********************************************
#assign node phase
#*********************************************
def assignNodePhase(NodeTable,NodeID,Phase):
	if NodeTable[NodeID][2] == '':
	    NodeTable[NodeID][2] = Phase
	elif NodeTable[NodeID][2] == 'A' and Phase in ("AB", "AC", "ABC", "ABCN"):
	    NodeTable[NodeID][2] = Phase
	elif NodeTable[NodeID][2] == 'B' and Phase in ("AB", "BC", "ABC", "ABCN"):
	    NodeTable[NodeID][2] = Phase
	elif NodeTable[NodeID][2] == 'C' and Phase in ("AC", "BC", "ABC", "ABCN"):
	    NodeTable[NodeID][2] = Phase
	elif NodeTable[NodeID][2] in ("AB", "AC", "BC") and Phase in ("ABC", "ABCN"):
	    NodeTable[NodeID][2] = Phase
	elif NodeTable[NodeID][2] == 'ABC' and Phase == 'ABCN':
	    NodeTable[NodeID][2] = Phase

	return NodeTable


#******************************************
# this subroutine determines if there are subgraphs
# in the graph and remove the smallest ones.
# The largest subgraph is returned as the graph
#******************************************
def HandleDisSub(G):
#determine if there are subgraphs not connected
	if not(nx.is_connected(G)):
		print "removing disconnected subgraphs..."
		connectList=nx.connected_components(G)

		#find which list is the largests
		maxIndex=0
		maxValue=0
		for i in range(len(connectList)):
			if len(connectList[i])>maxValue:
				maxIndex=i
				maxValue=len(connectList[i])

		#now to get the rest
		smallList=[]
		smallListcount=10000000000
		for i in range(len(connectList)):
			if i !=maxIndex:
				smallListcount=len(connectList[i])
				smallList.append(connectList[i])

		#create a list of edges to delete
		smallEdge=[]
		for i in range(len(smallList)):
			smallEdge.append(nx.edges(G,smallList[i]))

		#remove the edges
		for i in range(len(smallEdge)):
			for ii in range(len(smallEdge[i])):
				G.remove_edge(*smallEdge[i][ii])	

		#remove any isolated nodes
		IsoNodes=nx.isolates(G)
		for i in range(len(IsoNodes)):
			G.remove_node(IsoNodes[i])

	return G


#*********************************
# check ToNodes
# return section with ToNode or null
#*********************************
def CheckTo(Section,Node):
	TheSection=[]
	index=999999
	for i in range(len(Section)):			#go through all of the sections
		if Section[i][1]==Node:			#if its the same as the node
			TheSection=Section[i]		#set the output
			index=i
	return TheSection,index

#*********************************
# check FromNodes
# return section with FromNode or null
# if it finds a section it
# will reverse order of nodes
#*********************************
def CheckFrom(Section,Node):
	TheSection=[]
	index=999999
	for i in range(len(Section)):				#go through all of the sections
		if Section[i][2]==Node:				#if its the same as the node
			#fix the Node order
			try:
				TempSection=copy.deepcopy(Section[i])	#make a copy
				TempSection[1]=Section[i][2]		#reverse the nodes
				TempSection[2]=Section[i][1]
				TheSection=TempSection			#set output
				index=i
			except:
				#print Section[i]
				#print i
                                print "warning: check CheckFrom() copy.deepcopy"
	return TheSection,index


#*******************************
# create the proper order for
# section given headnode
# this is basically a breath-first search
# that returns the proper ordered sections
# section nodes are also properly order To-From
#*******************************
def OrderSections(Section,HeadNode):

	NewSection=[]			#empty list to contain proper order sections
	quenode=[]			#que of nodes to check
	quenode.append(HeadNode)	#load que with headnode
	SectionCount=0
	PrintCount=100

	while quenode !=[]:		#do as long as there are nodes left
		Node=quenode.pop(0)	#grab first node in que
		StillTo=True		#enable while statements
		StillFrom=True

		#check to nodes
		while StillTo:
			TheSection,index=CheckTo(Section,Node)		#check if there is a section from ToNodes
			if TheSection !=[]:				#if there is (not null)
				NewSection.append(TheSection)		#add section to new proper ordered list
				quenode.append(TheSection[2])		#add FromNode to que
				Section.pop(index)			#delete record from section list
			else:
				StillTo=False				#else done with ToNodes

		while StillFrom:
			TheSection,index=CheckFrom(Section,Node)	#check if there is a section from FromNode
			if TheSection !=[]:				#if there is (not null)
				NewSection.append(TheSection)		#add section to new proper ordered list
				quenode.append(TheSection[2])		#add FromNode to que
				Section.pop(index)			#delete record from section list
			else:
				StillFrom=False

		#give the status of progress
		SectionCount=SectionCount+1
		if SectionCount==PrintCount:
			#print "current section=",SectionCount
			PrintCount=PrintCount+100

	return NewSection	


#************************************************
# Assign appropriate voltage and distance from 
# the source to each node by traversing the tree 
# starting from the source node
#************************************************
def AssignNodeVoltages(G,NodeTable,thisNode,OHLineTable,UGLineTable):
	OutEdges = G.out_edges(thisNode)
	for i in range(len(OutEdges)):
    		OutEdge = OutEdges[i]
    		nextNode = OutEdge[1]
    		if G.edge[thisNode][nextNode]['type'] == 'OH':
        		# assign the voltage of thisnode to nextnode
        		NodeTable[nextNode][0] = NodeTable[thisNode][0]
			# assign the node distance from the source node
			edgeID = G.edge[thisNode][nextNode]['id']
			NodeTable[nextNode][3] = NodeTable[thisNode][3] + OHLineTable[edgeID][4]
    		elif G.edge[thisNode][nextNode]['type'] == 'UG':
        		# assign the voltage of thisnode to nextnode
        		NodeTable[nextNode][0] = NodeTable[thisNode][0]
			# assign the node distance from the source node
			edgeID = G.edge[thisNode][nextNode]['id']
			NodeTable[nextNode][3] = NodeTable[thisNode][3] + UGLineTable[edgeID][4]
    		if G.edge[thisNode][nextNode]['type'] == 'SW':
        		# assign the voltage of thisnode to nextnode
        		NodeTable[nextNode][0] = NodeTable[thisNode][0]
			# assign the node distance from the source node
			edgeID = G.edge[thisNode][nextNode]['id']
			NodeTable[nextNode][3] = NodeTable[thisNode][3]

		#else: # it is a tranformer
			# figure out how to handle a transformer ratio

		NodeTable = AssignNodeVoltages(G,NodeTable,nextNode,OHLineTable,UGLineTable)

	return NodeTable


#******************************************
#******************************************
#		Input Section - ENTER HERE
#******************************************
#******************************************

# xml file name
xmlfilename = "IEEE_13node_feeder1" #"Oceano_1106_v1"

# climate TMY2 file name
tmy2filename = "CA-San_francisco"

# climate csv file name
climatecsvfilename = "climate_csv"

# load shape
load_shape = 1

# load scaling
loadScale = 1

# Cyme version
cyme_ver = "7.1" # "5.4" #

#******************************************
#******************************************
#		Main Program
#******************************************
#******************************************

# Read in cyme xml file data
tree = ET.parse(xmlfilename + ".sxst")

# create the glm file to write the translated model
glmfilename = xmlfilename + "_glmfile"

print "Starting to write glm files..."
f=open(glmfilename + ".glm","w")
floads=open(glmfilename + "_loads.glm","w")
fnodedistance=open(glmfilename + "NodeDistance.csv","w")
fVVO=open(glmfilename + "_VVO.glm","w")
fPV=open(glmfilename + "_PV.glm","w")


#create the header
#f.write("// $Id: testPF_cymexml.glm \n")
f.write("//\n")
f.write("//********************************\n")
f.write("// A demonstration of cyme xml to Gridlab-D input\n")
f.write("// created by: Vaibhav Donde\n")
f.write("//\n")
f.write("\n")
f.write("clock{\n")
f.write("	timestamp '2002-01-01 0:00:00';\n")
f.write("	stoptime '2002-02-01 0:00:00';\n")
f.write("}\n")
f.write("#set profiler=1\n\n")

#create the module section
f.write("\n")
f.write("//********************************\n// modules\n//********************************\n")

f.write("module tape;\nmodule powerflow{\n")
f.write("	solver_method FBS;\n")
f.write("	default_maximum_voltage_error 1e-9;\n};\n\n")

# Tree
root = tree.getroot()

print "Parsing the network data from CYME xml..."

# Extract info for OH Conductor, create a dictionary
OHConductorTable = {}
for Equipments in root.findall('Equipments'):
    for Equipments2 in Equipments.findall('Equipments'):
        for EquipmentDBs in Equipments2.findall('EquipmentDBs'):
            for ConductorDB in EquipmentDBs.findall('ConductorDB'):
                EquipmentID = "OHCond_"+ConductorDB.find('EquipmentID').text
                FirstResistance = float(ConductorDB.find('FirstResistance').text)*1.6093	# ohm/km --> ohm/mi
                GMR = float(ConductorDB.find('GMR').text)*0.0328				# cm --> ft
                OutsideDiameter = float(ConductorDB.find('OutsideDiameter').text)*0.3937	# cm --> inch
		
                OHConductorTable[EquipmentID] = [FirstResistance,GMR,OutsideDiameter] 


# Extract info for line spacing objects, create a dictionary
LineSpacingTable = {}
for Equipments in root.findall('Equipments'):
    for Equipments2 in Equipments.findall('Equipments'):
        for EquipmentDBs in Equipments2.findall('EquipmentDBs'):
            for OverheadSpacingOfConductorDB in EquipmentDBs.findall('OverheadSpacingOfConductorDB'):
                EquipmentID = "OHSpacing_"+OverheadSpacingOfConductorDB.find('EquipmentID').text
                for GeometricalArrangement in OverheadSpacingOfConductorDB.findall('GeometricalArrangement'):
                    # actual distances
                    distA = GeometricalArrangement.find('DistanceA').text
                    distB = GeometricalArrangement.find('DistanceB').text
                    distC = GeometricalArrangement.find('DistanceC').text
                    distD = GeometricalArrangement.find('DistanceD').text
                    distE = GeometricalArrangement.find('DistanceE').text
                    distance_AB = float(distE)*3.2808 									# m --> ft
                    distance_BC = (2*float(distD)+float(distE))*3.2808 							# m --> ft
                    distance_AC = (2*float(distD)+2*float(distE))*3.2808 						# m --> ft
                    distance_AN = math.sqrt( float(distC)**2 + (float(distA)+float(distD)+float(distE))**2 )*3.2808 	# m --> ft
                    distance_BN = math.sqrt( float(distC)**2 + (float(distA)+float(distD))**2 )*3.2808 			# m --> ft
                    distance_CN = math.sqrt( float(distC)**2 + (float(distD)+float(distE)-float(distA))**2 )*3.2808 	# m --> ft
                    distance_AE = (float(distB)+float(distC))*3.2808 							# m --> ft
                    distance_BE = (float(distB)+float(distC))*3.2808 							# m --> ft
                    distance_CE = (float(distB)+float(distC))*3.2808 							# m --> ft
                    distance_NE = float(distB)*3.2808 									# m --> ft

                    LineSpacingTable[EquipmentID] = [distance_AB,distance_BC,distance_AC,distance_AN,distance_BN,distance_CN,distance_AE,distance_BE,distance_CE,distance_NE]

                for AverageGeometricalArrangement in OverheadSpacingOfConductorDB.findall('AverageGeometricalArrangement'):
                    # or average distances
                    distance_AB = float(AverageGeometricalArrangement.find('GMDPhaseToPhase').text)*3.2808 		# m --> ft
                    distance_BC = distance_AB
                    distance_AC = distance_AB
                    distance_AN = float(AverageGeometricalArrangement.find('GMDPhaseToNeutral').text)*3.2808 		# m --> ft
                    distance_BN = distance_AN
                    distance_CN = distance_AN

                    LineSpacingTable[EquipmentID] = [distance_AB,distance_BC,distance_AC,distance_AN,distance_BN,distance_CN,'','','','']



# Extract info for OH line config objects, create a dictionary
LineConfigTable = {}
CableConfigTable = {}
UGConductorTable = {}
CableConfigTable_z = {}
for Equipments in root.findall('Equipments'):
    for Equipments2 in Equipments.findall('Equipments'):
        for EquipmentDBs in Equipments2.findall('EquipmentDBs'):
            for OverheadLineDB in EquipmentDBs.findall('OverheadLineDB'):
                EquipmentID = "OHConfig_"+OverheadLineDB.find('EquipmentID').text
                conductor_A = "OHCond_"+OverheadLineDB.find('PhaseConductorID').text
                conductor_B = "OHCond_"+OverheadLineDB.find('PhaseConductorID').text
                conductor_C = "OHCond_"+OverheadLineDB.find('PhaseConductorID').text
                conductor_N = "OHCond_"+OverheadLineDB.find('NeutralConductorID').text
                spacing = "OHSpacing_"+OverheadLineDB.find('ConductorSpacingID').text
                LineConfigTable[EquipmentID] = [conductor_A,conductor_B,conductor_C,conductor_N,spacing]

            for OverheadLineDB in EquipmentDBs.findall('OverheadLineUnbalancedDB'):
		# for Cyme version 7.1
                EquipmentID = "OHConfig_"+OverheadLineDB.find('EquipmentID').text
                conductor_A = "OHCond_"+OverheadLineDB.find('PhaseConductorIDA').text
                conductor_B = "OHCond_"+OverheadLineDB.find('PhaseConductorIDB').text
                conductor_C = "OHCond_"+OverheadLineDB.find('PhaseConductorIDC').text
                conductor_N = "OHCond_"+OverheadLineDB.find('NeutralConductorID').text
                spacing = "OHSpacing_"+OverheadLineDB.find('ConductorSpacingID').text
                LineConfigTable[EquipmentID] = [conductor_A,conductor_B,conductor_C,conductor_N,spacing]

            for CableDB in EquipmentDBs.findall('CableDB'):
                EquipmentID = CableDB.find('EquipmentID').text
                UGCableID = "UGCable_" + EquipmentID

                #conductor_resistance = CableDB.find('PositiveSequenceResistance').text
                #neutral_resistance = CableDB.find('ZeroSequenceResistance').text


                for CableConfiguration in CableDB.findall('CableConfiguration'):

                    ####################################
                    # populate line_configuration fields
                    ####################################
                    element_ph = CableConfiguration.find('PhaseConductorID').text
                    if element_ph:
                        conductor_A = "UGCable_" + element_ph
                        conductor_B = "UGCable_" + element_ph
                        conductor_C = "UGCable_" + element_ph
                        #PhaseConductorID = "UGCable_" + element_ph
                    else:
                        # for the case where it is not specified
                        conductor_A = ''
                        conductor_B = ''
                        conductor_C = ''
                        #PhaseConductorID = ''
                    element_n = CableConfiguration.find('NeutralConductorID').text
                    if element_n:
                        conductor_N = "UGCable_" + element_n
                        NeutralConductorID = "UGCable_" + element_n
                    else:
                        # for the case where it is not specified
                        conductor_N = ''
                        NeutralConductorID = ''

                    UGConfigID = "UGConfig_" + EquipmentID
                    UGSpacingID = "UGSpacing_" + EquipmentID

                    CableConfigTable[UGConfigID] = [conductor_A,conductor_B,conductor_C,conductor_N,UGSpacingID]

                    ##############################
                    # populate line_spacing fields
                    ##############################
                    distance_AB = float(CableConfiguration.find('DistanceBetweenABPhases').text)*0.032808 	# cm --> ft
                    distance_BC = float(CableConfiguration.find('DistanceBetweenBCPhases').text)*0.032808 	# cm --> ft
                    distance_AC = float(CableConfiguration.find('DistanceBetweenACPhases').text)*0.032808 	# cm --> ft

                    LineSpacingTable[UGSpacingID] = [distance_AB,distance_BC,distance_AC,'','','','','','','']


                    ############################################
                    # populate underground_line_conductor fields
                    ############################################
                    outer_diameter = float(CableConfiguration.find('InsulationDiameter').text)*0.393701 		# cm --> in
                    insultation_relative_permitivitty = CableConfiguration.find('InsulationDielectricConstant').text

                    conductor_gmr = OHConductorTable["OHCond_" + element_ph][1] 		# ft
                    conductor_diameter = OHConductorTable["OHCond_" + element_ph][2]		# in
                    conductor_resistance = OHConductorTable["OHCond_" + element_ph][0]		# ohm/mile

                    neutral_gmr = OHConductorTable["OHCond_" + element_n][1]			# ft
                    neutral_diameter = OHConductorTable["OHCond_" + element_n][2]		# in
                    neutral_resistance = OHConductorTable["OHCond_" + element_n][0]		# ohm/mile
                    neutral_strands = CableConfiguration.find('NumberOfNeutralWire').text

                    shield_gmr = ''								# ft
                    shield_resistance = ''							# ohm/mile

                    UGConductorTable[UGCableID] = [outer_diameter,conductor_gmr,conductor_diameter,conductor_resistance,neutral_gmr,neutral_resistance,neutral_diameter,neutral_strands,shield_gmr,shield_resistance]

                if cyme_ver == "7.1":
                    UserDefinedImpedances = CableDB.find('UserDefinedImpedances').text
                    if UserDefinedImpedances == '1':
                        PosSeqR = float(CableDB.find('PositiveSequenceResistance').text)*1.609			# ohm/km --> ohm/mile
                        PosSeqX = float(CableDB.find('PositiveSequenceReactance').text)*1.609			# ohm/km --> ohm/mile
                        ZeroSeqR = float(CableDB.find('ZeroSequenceResistance').text)*1.609			# ohm/km --> ohm/mile
                        ZeroSeqX = float(CableDB.find('ZeroSequenceReactance').text)*1.609			# ohm/km --> ohm/mile
                        R_self = str((2*PosSeqR+ZeroSeqR)/3)
                        X_self = str((2*PosSeqX+ZeroSeqX)/3)
                        R_mutual = str((ZeroSeqR-PosSeqR)/3)
                        X_mutual = str((ZeroSeqX-PosSeqX)/3)

                        UGConfigID = "UGConfig_" + EquipmentID
                        CableConfigTable_z[UGConfigID] = [R_self,X_self,R_mutual,X_mutual]



# Extract info for nodes and create a dictionary
NodeTable = {}
for Networks in root.findall('Networks'):
    for Network in Networks.findall('Network'):
        for Nodes in Network.findall('Nodes'):
            for Node in Nodes.findall('Node'):
                nodeID = "N_" + Node.find('NodeID').text
                UserDefinedBaseVoltage = Node.find('UserDefinedBaseVoltage').text
                #UserDefinedBaseVoltage = "7.2" # This should be automated by traversing the tree starting from the source node
                #if float(UserDefinedBaseVoltage) <= 0:
                #    BusType = 'g'
                #else:
                BusType = 'b'

                NodeTable[nodeID] = [float(UserDefinedBaseVoltage)*1000,BusType,'',0]


# Extract info for sources and create a dictionary
SourceTable = {}
for Networks in root.findall('Networks'):
    for Network in Networks.findall('Network'):
        for Topos in Network.findall('Topos'):
            for Topo in Topos.findall('Topo'):
                for Sources in Topo.findall('Sources'):
                    for Source in Sources.findall('Source'):
                        sourceNodeID = "N_" + Source.find('SourceNodeID').text
                        SourceTable[sourceNodeID] = 'S'
                        # set bustype to 'S' (swing) for this source
                        NodeTable[sourceNodeID][1] = 'S'
                        for EquivalentSource in Source.findall('EquivalentSource'):
                            #UserDefinedBaseVoltage = EquivalentSource.find('KVLL').text
                            UserDefinedBaseVoltage = EquivalentSource.find('OperatingVoltage1_KVLN').text
                            NodeTable[sourceNodeID][0] = float(UserDefinedBaseVoltage)*1000


# Extract info for sections and lines. create a dictionary
OHLineTable = {}
SpotLoadTable = {}
SwitchTable = {}
UGLineTable = {}
ShuntCapTable = {}
PVTable = {}
for Networks in root.findall('Networks'):
    for Network in Networks.findall('Network'):
        for Sections in Network.findall('Sections'):
            for Section in Sections.findall('Section'):
                FromNodeID = "N_" + Section.find('FromNodeID').text
                ToNodeID = "N_" + Section.find('ToNodeID').text
                Phase = Section.find('Phase').text
                # assign phase to FromNodeId and ToNodeId
                NodeTable = assignNodePhase(NodeTable,FromNodeID,Phase)	#	modify this: don't do this for sections having open switches => do only if SectionStatus = "Closed"
                NodeTable = assignNodePhase(NodeTable,ToNodeID,Phase)
                for Devices in Section.findall('Devices'):
                    SectionStatus = "Closed" # initialize to closed (V Donde 07072014)
                    SectionSwitch = "No" # initialize to no switch equipment on this section 
                    SectionOHorUG = "No" # initialize to no OH or UG or PV or load on this section

                    # First go through all the switching devices on this section
                    # if a single switching device if open, set the Section status as Open
                    for child in Devices:
                        DeviceType = child.tag
                        DeviceNumber = child.find('DeviceNumber').text
                        if DeviceType in ("Switch", "Fuse", "Breaker", "Recloser"):
                            SectionSwitch = "Yes"
                            NormalStatus = child.find('NormalStatus').text
                            if NormalStatus == "Open": 	# (V Donde 07072014)
                                SectionStatus = "Open" 	# (V Donde 07072014)
				break 			# (V Donde 07072014)


                    # If there is no switch equipment on the section, set section status to closed
                    if SectionStatus == "Open" and SectionSwitch == "No":
                        SectionStatus = "Closed"

                    # Now go through all the OH and UG lines on this section
                    # if Section status is Closed --> account for all OH or UG lines on this section if length>0, ignore the Closed switch
                    for child in Devices:
                        DeviceType = child.tag
                        DeviceNumber = "L_"+child.find('DeviceNumber').text
                        if SectionStatus == "Closed":
                            if DeviceType == 'OverheadLine':
                                # Overhead line
                                DeviceLength = float(child.find('Length').text)*3.28084 # m --> ft
                                SectionOHorUG = "Yes"
                                '''if float(NodeTable[FromNodeID][0]) > 0.0:
                                    NodeTable[ToNodeID][0] = NodeTable[FromNodeID][0]
                                elif float(NodeTable[ToNodeID][0]) > 0.0:
                                    NodeTable[FromNodeID][0] = NodeTable[ToNodeID][0]'''

                                if DeviceLength > 0.0:
                                    LineConfig = "OHConfig_"+child.find('LineID').text
                                    OHLineTable[DeviceNumber] = [FromNodeID,ToNodeID,Phase,DeviceType,DeviceLength,LineConfig]
                                else:
                                    # add a closed switch
                                    SwitchID = DeviceNumber + "_Switch"
                                    SwitchTable[SwitchID] = [FromNodeID,ToNodeID,Phase,"CLOSED"]
                            elif DeviceType == 'OverheadByPhase':
                                # Overheadbyphase line
                                DeviceLength = float(child.find('Length').text)*3.28084 # m --> ft
                                SectionOHorUG = "Yes"
                                '''if float(NodeTable[FromNodeID][0]) > 0.0:
                                    NodeTable[ToNodeID][0] = NodeTable[FromNodeID][0]
                                elif float(NodeTable[ToNodeID][0]) > 0.0:
                                    NodeTable[FromNodeID][0] = NodeTable[ToNodeID][0]'''

                                if DeviceLength > 0.0: 
                                    # Make an entry to LineConfigTable
                                    LineConfig = DeviceNumber + "_LineConfig"
                                    conductor_A = "OHCond_"+child.find('PhaseConductorIDA').text
                                    conductor_B = "OHCond_"+child.find('PhaseConductorIDB').text
                                    conductor_C = "OHCond_"+child.find('PhaseConductorIDC').text
                                    conductor_N = "OHCond_"+child.find('NeutralConductorID').text
                                    spacing = "OHSpacing_"+child.find('ConductorSpacingID').text
                                    LineConfigTable[LineConfig] = [conductor_A,conductor_B,conductor_C,conductor_N,spacing]
                                    # Make an entry to OHLineTable
                                    OHLineTable[DeviceNumber] = [FromNodeID,ToNodeID,Phase,DeviceType,DeviceLength,LineConfig]
                                else:
                                    # add a closed switch
                                    SwitchID = DeviceNumber + "_Switch"
                                    SwitchTable[SwitchID] = [FromNodeID,ToNodeID,Phase,"CLOSED"]
                            if DeviceType == 'OverheadLineUnbalanced':
                                # Overhead line unbalanced for Cyme version 7.1
                                DeviceLength = float(child.find('Length').text)*3.28084 # m --> ft
                                SectionOHorUG = "Yes"
                                '''if float(NodeTable[FromNodeID][0]) > 0.0:
                                    NodeTable[ToNodeID][0] = NodeTable[FromNodeID][0]
                                elif float(NodeTable[ToNodeID][0]) > 0.0:
                                    NodeTable[FromNodeID][0] = NodeTable[ToNodeID][0]'''

                                if DeviceLength > 0.0:
                                    LineConfig = "OHConfig_"+child.find('LineID').text
                                    OHLineTable[DeviceNumber] = [FromNodeID,ToNodeID,Phase,DeviceType,DeviceLength,LineConfig]
                                else:
                                    # add a closed switch
                                    SwitchID = DeviceNumber + "_Switch"
                                    SwitchTable[SwitchID] = [FromNodeID,ToNodeID,Phase,"CLOSED"]
                            elif DeviceType == 'Underground':
                                # underground cable
                                DeviceLength = float(child.find('Length').text)*3.28084 # m --> ft
                                SectionOHorUG = "Yes"
                                '''if float(NodeTable[FromNodeID][0]) > 0.0:
                                    NodeTable[ToNodeID][0] = NodeTable[FromNodeID][0]
                                elif float(NodeTable[ToNodeID][0]) > 0.0:
                                    NodeTable[FromNodeID][0] = NodeTable[ToNodeID][0]'''

                                if DeviceLength > 0.0:
                                    LineConfig = "UGConfig_"+child.find('CableID').text
                                    UGLineTable[DeviceNumber] = [FromNodeID,ToNodeID,Phase,DeviceType,DeviceLength,LineConfig]
                                else:
                                    # add a closed switch
                                    SwitchID = DeviceNumber + "_Switch"
                                    SwitchTable[SwitchID] = [FromNodeID,ToNodeID,Phase,"CLOSED"]
                            elif DeviceType == 'ShuntCapacitor':
                                SectionOHorUG = "Yes"
                                CapID = FromNodeID + "_Cap"

                                if cyme_ver == "5.4":
                                    PhasesConnected = child.find('Phase').text
                                    capacitor_A = float(child.find('KVARA').text)*1000
                                    capacitor_B = float(child.find('KVARB').text)*1000
                                    capacitor_C = float(child.find('KVARC').text)*1000
                                    if child.find('SwitchedCapacitorStatus').text == "InitiallyOn":
                                        switchA = "CLOSED"
                                        switchB = "CLOSED"
                                        switchC = "CLOSED"
                                    else:
                                        switchA = "OPEN"
                                        switchB = "OPEN"
                                        switchC = "OPEN"

                                    CapControl = child.find('CapacitorControl')
                                    if CapControl.get('Type') == "VoltageControlled":
                                        CapControlGLD = "VOLT"
                                        voltage_set_high = CapControl.find('OffVoltage').text
                                        voltage_set_low = CapControl.find('OnVoltage').text
                                        ParticipatingPhase = CapControl.find('ControlledPhase').text
                                        control_level = "INDIVIDUAL"
                                        time_delay = "100.0"
                                        dwell_time = "0.0"
                                    else:
                                        CapControlGLD = "MANUAL"
                                        voltage_set_high = "0.0"
                                        voltage_set_low = "0.0"
                                        ParticipatingPhase = "ABC"
                                        control_level = "INDIVIDUAL"
                                        time_delay = "100.0"
                                        dwell_time = "0.0"
                                elif cyme_ver == "7.1":
                                    PhasesConnected = Phase
                                    capacitor_A = float(child.find('FixedKVARA').text)*1000
                                    capacitor_B = float(child.find('FixedKVARB').text)*1000
                                    capacitor_C = float(child.find('FixedKVARC').text)*1000
                                    switchA = "OPEN"
                                    switchB = "OPEN"
                                    switchC = "OPEN"
                                    CapControlGLD = "MANUAL"
                                    voltage_set_high = "0.0"
                                    voltage_set_low = "0.0"
                                    ParticipatingPhase = "ABC"
                                    control_level = "INDIVIDUAL"
                                    time_delay = "100.0"
                                    dwell_time = "0.0"
                                
                                nominal_voltage = float(child.find('KVLN').text)*1000



                                ShuntCapTable[CapID] = [Phase,PhasesConnected,ParticipatingPhase,FromNodeID,CapControlGLD,voltage_set_high,voltage_set_low,capacitor_A,capacitor_B,capacitor_C,control_level,time_delay,dwell_time,switchA,switchB,switchC,nominal_voltage]

                            elif DeviceType == 'Photovoltaic':
                                SectionOHorUG = "Yes"
                                generator_mode = "SUPPLY_DRIVEN"
                                inverter_mode = "CONSTANT_PF"
                                inverter_type = "PWM"
                                if cyme_ver == "5.4":
                                    power_factor = float(child.find('PowerFactor').text)*0.01
                                elif cyme_ver == "7.1":
                                    for GenerationModels in child.findall('GenerationModels'):
                                        for DCGenerationModel in GenerationModels.findall('DCGenerationModel'):
                                            power_factor = float(DCGenerationModel.find('PowerFactor').text)*0.01

                                solar_efficiency = 0.2		# get the actual efficiency
                                solar_area = 500		# get the actual area sf
                                rated_power = 30000.00		# get the actual rated Watts
                                inverter_efficiency = 0.9	# get the actual efficiency
                                pri_voltage = 2400		# this will be corrected after the nodes are assigned the right voltages
                                sec_voltage = 120		# get the actual secondary voltage
                                #Xfrm_config = "Xfrm_config_PV_" + DeviceNumber
                                Xfrm_connect_type = "SINGLE_PHASE_CENTER_TAPPED"
                                Xfrm_install_type = "POLETOP"
                                Xfrm_power_rating = 10000	# get the actual rating
                                Xfrm_resistance = 0.09		# get the actual resistance
                                Xfrm_reactance = 1.81		# get the actual reactance
                                

                                if child.find('ConnectionStatus') == "Connected":
                                    generator_status = "ONLINE"
                                else:
                                    generator_status = "OFFLINE"
                                panel_type = "SINGLE_CRYSTAL_SILICON"


                                PVPhase = child.find('Phase').text
                                if PVPhase in ("A", "B", "C"):
                                    PVID = "PV_" + DeviceNumber + "_" + PVPhase
                                    SolarID = "solar_" + DeviceNumber + "_" + PVPhase
                                    InverterID = "inverter_" + DeviceNumber + "_" + PVPhase
                                    #InverterNodeID = FromNodeID + "_sec_" + PVPhase
                                    InverterNodeID = "N_" + DeviceNumber + "_sec_" + PVPhase
                                    InverterPhase = PVPhase + "S"
                                    XfrmID = "Xfrm_" + DeviceNumber + "_" + PVPhase
                                    Xfrm_config = "Xfrm_config_PV_" + DeviceNumber + "_" + PVPhase
                                    PVTable[PVID] = [SolarID,InverterID,generator_mode,generator_status,panel_type,solar_efficiency,solar_area,InverterNodeID,InverterPhase,inverter_mode,inverter_type,power_factor,rated_power,inverter_efficiency,FromNodeID,pri_voltage,sec_voltage,XfrmID,Xfrm_config,Xfrm_connect_type,Xfrm_install_type,Xfrm_power_rating,Xfrm_resistance,Xfrm_reactance]
                                elif PVPhase in ("AB", "BA"):
                                    PVID = "PV_" + DeviceNumber + "_A"
                                    SolarID = "solar_" + DeviceNumber + "_A"
                                    InverterID = "inverter_" + DeviceNumber + "_A"
                                    #InverterNodeID = FromNodeID + "_sec_A"
                                    InverterNodeID = "N_" + DeviceNumber + "_sec_A"
                                    InverterPhase = "AS"
                                    XfrmID = "Xfrm_" + DeviceNumber + "_A"
                                    Xfrm_config = "Xfrm_config_PV_" + DeviceNumber + "_A"
                                    PVTable[PVID] = [SolarID,InverterID,generator_mode,generator_status,panel_type,solar_efficiency,solar_area,InverterNodeID,InverterPhase,inverter_mode,inverter_type,power_factor,rated_power,inverter_efficiency,FromNodeID,pri_voltage,sec_voltage,XfrmID,Xfrm_config,Xfrm_connect_type,Xfrm_install_type,Xfrm_power_rating,Xfrm_resistance,Xfrm_reactance]
                                    PVID = "PV_" + DeviceNumber + "_B"
                                    SolarID = "solar_" + DeviceNumber + "_B"
                                    InverterID = "inverter_" + DeviceNumber + "_B"
                                    #InverterNodeID = FromNodeID + "_sec_B"
                                    InverterNodeID = "N_" + DeviceNumber + "_sec_B"
                                    InverterPhase = "BS"
                                    XfrmID = "Xfrm_" + DeviceNumber + "_B"
                                    Xfrm_config = "Xfrm_config_PV_" + DeviceNumber + "_B"
                                    PVTable[PVID] = [SolarID,InverterID,generator_mode,generator_status,panel_type,solar_efficiency,solar_area,InverterNodeID,InverterPhase,inverter_mode,inverter_type,power_factor,rated_power,inverter_efficiency,FromNodeID,pri_voltage,sec_voltage,XfrmID,Xfrm_config,Xfrm_connect_type,Xfrm_install_type,Xfrm_power_rating,Xfrm_resistance,Xfrm_reactance]
                                elif PVPhase in ("BC", "CB"):
                                    PVID = "PV_" + DeviceNumber + "_B"
                                    SolarID = "solar_" + DeviceNumber + "_B"
                                    InverterID = "inverter_" + DeviceNumber + "_B"
                                    #InverterNodeID = FromNodeID + "_sec_B"
                                    InverterNodeID = "N_" + DeviceNumber + "_sec_B"
                                    InverterPhase = "BS"
                                    XfrmID = "Xfrm_" + DeviceNumber + "_B"
                                    Xfrm_config = "Xfrm_config_PV_" + DeviceNumber + "_B"
                                    PVTable[PVID] = [SolarID,InverterID,generator_mode,generator_status,panel_type,solar_efficiency,solar_area,InverterNodeID,InverterPhase,inverter_mode,inverter_type,power_factor,rated_power,inverter_efficiency,FromNodeID,pri_voltage,sec_voltage,XfrmID,Xfrm_config,Xfrm_connect_type,Xfrm_install_type,Xfrm_power_rating,Xfrm_resistance,Xfrm_reactance]
                                    PVID = "PV_" + DeviceNumber + "_C"
                                    SolarID = "solar_" + DeviceNumber + "_C"
                                    InverterID = "inverter_" + DeviceNumber + "_C"
                                    #InverterNodeID = FromNodeID + "_sec_C"
                                    InverterNodeID = "N_" + DeviceNumber + "_sec_C"
                                    InverterPhase = "CS"
                                    XfrmID = "Xfrm_" + DeviceNumber + "_C"
                                    Xfrm_config = "Xfrm_config_PV_" + DeviceNumber + "_C"
                                    PVTable[PVID] = [SolarID,InverterID,generator_mode,generator_status,panel_type,solar_efficiency,solar_area,InverterNodeID,InverterPhase,inverter_mode,inverter_type,power_factor,rated_power,inverter_efficiency,FromNodeID,pri_voltage,sec_voltage,XfrmID,Xfrm_config,Xfrm_connect_type,Xfrm_install_type,Xfrm_power_rating,Xfrm_resistance,Xfrm_reactance]
                                elif PVPhase in ("CA", "AC"):
                                    PVID = "PV_" + DeviceNumber + "_A"
                                    SolarID = "solar_" + DeviceNumber + "_A"
                                    InverterID = "inverter_" + DeviceNumber + "_A"
                                    #InverterNodeID = FromNodeID + "_sec_A"
                                    InverterNodeID = "N_" + DeviceNumber + "_sec_A"
                                    InverterPhase = "AS"
                                    XfrmID = "Xfrm_" + DeviceNumber + "_A"
                                    Xfrm_config = "Xfrm_config_PV_" + DeviceNumber + "_A"
                                    PVTable[PVID] = [SolarID,InverterID,generator_mode,generator_status,panel_type,solar_efficiency,solar_area,InverterNodeID,InverterPhase,inverter_mode,inverter_type,power_factor,rated_power,inverter_efficiency,FromNodeID,pri_voltage,sec_voltage,XfrmID,Xfrm_config,Xfrm_connect_type,Xfrm_install_type,Xfrm_power_rating,Xfrm_resistance,Xfrm_reactance]
                                    PVID = "PV_" + DeviceNumber + "_C"
                                    SolarID = "solar_" + DeviceNumber + "_C"
                                    InverterID = "inverter_" + DeviceNumber + "_C"
                                    #InverterNodeID = FromNodeID + "_sec_C"
                                    InverterNodeID = "N_" + DeviceNumber + "_sec_C"
                                    InverterPhase = "CS"
                                    XfrmID = "Xfrm_" + DeviceNumber + "_C"
                                    Xfrm_config = "Xfrm_config_PV_" + DeviceNumber + "_C"
                                    PVTable[PVID] = [SolarID,InverterID,generator_mode,generator_status,panel_type,solar_efficiency,solar_area,InverterNodeID,InverterPhase,inverter_mode,inverter_type,power_factor,rated_power,inverter_efficiency,FromNodeID,pri_voltage,sec_voltage,XfrmID,Xfrm_config,Xfrm_connect_type,Xfrm_install_type,Xfrm_power_rating,Xfrm_resistance,Xfrm_reactance]
                                elif PVPhase in ("ABC", "ABCN"):
                                    PVID = "PV_" + DeviceNumber + "_A"
                                    SolarID = "solar_" + DeviceNumber + "_A"
                                    InverterID = "inverter_" + DeviceNumber + "_A"
                                    #InverterNodeID = FromNodeID + "_sec_A"
                                    InverterNodeID = "N_" + DeviceNumber + "_sec_A"
                                    InverterPhase = "AS"
                                    XfrmID = "Xfrm_" + DeviceNumber + "_A"
                                    Xfrm_config = "Xfrm_config_PV_" + DeviceNumber + "_A"
                                    PVTable[PVID] = [SolarID,InverterID,generator_mode,generator_status,panel_type,solar_efficiency,solar_area,InverterNodeID,InverterPhase,inverter_mode,inverter_type,power_factor,rated_power,inverter_efficiency,FromNodeID,pri_voltage,sec_voltage,XfrmID,Xfrm_config,Xfrm_connect_type,Xfrm_install_type,Xfrm_power_rating,Xfrm_resistance,Xfrm_reactance]
                                    PVID = "PV_" + DeviceNumber + "_B"
                                    SolarID = "solar_" + DeviceNumber + "_B"
                                    InverterID = "inverter_" + DeviceNumber + "_B"
                                    #InverterNodeID = FromNodeID + "_sec_B"
                                    InverterNodeID = "N_" + DeviceNumber + "_sec_B"
                                    InverterPhase = "BS"
                                    XfrmID = "Xfrm_" + DeviceNumber + "_B"
                                    Xfrm_config = "Xfrm_config_PV_" + DeviceNumber + "_B"
                                    PVTable[PVID] = [SolarID,InverterID,generator_mode,generator_status,panel_type,solar_efficiency,solar_area,InverterNodeID,InverterPhase,inverter_mode,inverter_type,power_factor,rated_power,inverter_efficiency,FromNodeID,pri_voltage,sec_voltage,XfrmID,Xfrm_config,Xfrm_connect_type,Xfrm_install_type,Xfrm_power_rating,Xfrm_resistance,Xfrm_reactance]
                                    PVID = "PV_" + DeviceNumber + "_C"
                                    SolarID = "solar_" + DeviceNumber + "_C"
                                    InverterID = "inverter_" + DeviceNumber + "_C"
                                    #InverterNodeID = FromNodeID + "_sec_C"
                                    InverterNodeID = "N_" + DeviceNumber + "_sec_C"
                                    InverterPhase = "CS"
                                    XfrmID = "Xfrm_" + DeviceNumber + "_C"
                                    Xfrm_config = "Xfrm_config_PV_" + DeviceNumber + "_C"
                                    PVTable[PVID] = [SolarID,InverterID,generator_mode,generator_status,panel_type,solar_efficiency,solar_area,InverterNodeID,InverterPhase,inverter_mode,inverter_type,power_factor,rated_power,inverter_efficiency,FromNodeID,pri_voltage,sec_voltage,XfrmID,Xfrm_config,Xfrm_connect_type,Xfrm_install_type,Xfrm_power_rating,Xfrm_resistance,Xfrm_reactance]




                    # Now go through all the loads on this section
                    for child in Devices:
                        DeviceType = child.tag
                        DeviceNumber = child.find('DeviceNumber').text
                        if DeviceType == 'SpotLoad':
                            SectionOHorUG = "Yes"
                            if child.find('Location').text == 'To':
                                ConnectedNodeID = ToNodeID
                            else:
                                ConnectedNodeID = FromNodeID

                            for CustomerLoads in child.findall('CustomerLoads'):
                                for CustomerLoad in CustomerLoads.findall('CustomerLoad'):
                                    for CustomerLoadModels in CustomerLoad.findall('CustomerLoadModels'):
                                        for CustomerLoadModel in CustomerLoadModels.findall('CustomerLoadModel'):
                                            for CustomerLoadValues in CustomerLoadModel.findall('CustomerLoadValues'):
                                                PA = 0;
                                                PB = 0;
                                                PC = 0;
                                                QA = 0;
                                                QB = 0;
                                                QC = 0;
                                                for CustomerLoadValue in CustomerLoadValues.findall('CustomerLoadValue'):
                                                    if CustomerLoadValue.find('Phase').text == 'A':
                                                        for LoadValue in CustomerLoadValue.findall('LoadValue'):
                                                            PA = PA + float(LoadValue.find('KW').text)*1000*loadScale
                                                            if LoadValue.attrib['Type'] == 'LoadValueKW_KVAR':
                                                                QA = QA + float(LoadValue.find('KVAR').text)*1000*loadScale
                                                            elif LoadValue.attrib['Type'] == 'LoadValueKW_PF':
                                                                PF = float(LoadValue.find('PF').text)/100
                                                                QA = QA + PA*math.tan(math.acos(PF))
                                                    elif CustomerLoadValue.find('Phase').text == 'B':
                                                        for LoadValue in CustomerLoadValue.findall('LoadValue'):
                                                            PB = PB + float(LoadValue.find('KW').text)*1000*loadScale
                                                            if LoadValue.attrib['Type'] == 'LoadValueKW_KVAR':
                                                                QB = QB + float(LoadValue.find('KVAR').text)*1000*loadScale
                                                            elif LoadValue.attrib['Type'] == 'LoadValueKW_PF':
                                                                PF = float(LoadValue.find('PF').text)/100
                                                                QB = QB + PB*math.tan(math.acos(PF))
                                                    elif CustomerLoadValue.find('Phase').text == 'C':
                                                        for LoadValue in CustomerLoadValue.findall('LoadValue'):
                                                            PC = PC + float(LoadValue.find('KW').text)*1000*loadScale
                                                            if LoadValue.attrib['Type'] == 'LoadValueKW_KVAR':
                                                                QC = QC + float(LoadValue.find('KVAR').text)*1000*loadScale
                                                            elif LoadValue.attrib['Type'] == 'LoadValueKW_PF':
                                                                PF = float(LoadValue.find('PF').text)/100
                                                                QC = QC + PC*math.tan(math.acos(PF))
                                                    elif CustomerLoadValue.find('Phase').text == 'ABC':
                                                        for LoadValue in CustomerLoadValue.findall('LoadValue'):
                                                            PA = PA + float(LoadValue.find('KW').text)*1000*loadScale/3
                                                            PB = PA
                                                            PC = PA
                                                            if LoadValue.attrib['Type'] == 'LoadValueKW_KVAR':
                                                                QA = QA + float(LoadValue.find('KVAR').text)*1000*loadScale/3
                                                                QB = QA
                                                                QC = QA
                                                            elif LoadValue.attrib['Type'] == 'LoadValueKW_PF':
                                                                PF = float(LoadValue.find('PF').text)/100
                                                                QA = QA + PA*math.tan(math.acos(PF))
                                                                QB = QA
                                                                QC = QA

                                                NotPresent = True
                                                for key in SpotLoadTable:
                                                    if key == ConnectedNodeID:
                                                        NotPresent = False
                                                        break

                                                if NotPresent:
                                                    SpotLoadTable[ConnectedNodeID] = [ConnectedNodeID,Phase,DeviceType,0.0,PA,QA,PB,QB,PC,QC,0.0]
                                                else:
                                                    # add the loads
                                                    PA = PA + SpotLoadTable[key][4]
                                                    QA = QA + SpotLoadTable[key][5]
                                                    PB = PB + SpotLoadTable[key][6]
                                                    QB = QB + SpotLoadTable[key][7]
                                                    PC = PC + SpotLoadTable[key][8]
                                                    QC = QC + SpotLoadTable[key][9]

                                                    SpotLoadTable[ConnectedNodeID] = [ConnectedNodeID,Phase,DeviceType,0.0,PA,QA,PB,QB,PC,QC,0.0]
                                                    #SpotLoadTable[DeviceNumber] = [ConnectedNodeID,Phase,DeviceType,0,PA,QA,PB,QB,PC,QC]
                        #else:
                        #    print (DeviceType, DeviceNumber, FromNodeID, ToNodeID, Phase)


                    # if Section status is Closed AND no non-switch devices on this section --> account for this Closed switch
                    # if Section status is Open --> ignore all the non-switch devices on this section, if any; ignore the Open switch
                    for child in Devices:
                        DeviceType = child.tag
                        DeviceNumber = "S_" + child.find('DeviceNumber').text
                        if SectionStatus == "Closed" and SectionOHorUG == "No":
                            # add a closed switch
                            SwitchID = DeviceNumber + "_Switch"
                            SwitchTable[SwitchID] = [FromNodeID,ToNodeID,Phase,"CLOSED"]



#*********************************
# create graph and plot trees 
#*********************************

print "Creating graph and plotting tree..."

# initialize the graph
G=nx.Graph()

# add nodes, edges
for key in NodeTable:
    G.add_node(key)

for key in OHLineTable:
    G.add_edge(OHLineTable[key][0],OHLineTable[key][1])

for key in UGLineTable:
    G.add_edge(UGLineTable[key][0],UGLineTable[key][1])

for key in SwitchTable:
    G.add_edge(SwitchTable[key][0],SwitchTable[key][1])


#remove any isolated nodes
#IsoNodes=nx.isolates(G) #get a list of isloated nodes
#for i in range(len(IsoNodes)):
#	G.remove_node(IsoNodes[i])

#remove any subgraphs
print "Removing any subgraphs or disconnected sections..."
G=HandleDisSub(G)

# get the headnode
HeadNode = []
for key in SourceTable:
    if key in G.nodes():
        HeadNode.append(key)
    
# create branch table from OHLineTable, UGLineTable, SwitchTable
BranchTable = []
for key in OHLineTable:
    BranchTable.append([key,OHLineTable[key][0],OHLineTable[key][1],'OH'])

for key in UGLineTable:
    BranchTable.append([key,UGLineTable[key][0],UGLineTable[key][1],'UG'])

for key in SwitchTable:
    BranchTable.append([key,SwitchTable[key][0],SwitchTable[key][1],'SW'])


OrderedBranchTable = OrderSections(BranchTable,HeadNode[0]) # OrderedBranchTable has only the sections in a tree starting from HeadNode

#************************************
# make a directed graph using DiGraph
#************************************
print "Making a directed graph..."
DG=nx.DiGraph()
for i in range(len(OrderedBranchTable)):
	DG.add_edge(OrderedBranchTable[i][1],OrderedBranchTable[i][2],type=OrderedBranchTable[i][3],id=OrderedBranchTable[i][0])

#************************************
# clean up node and load tables
#************************************

# assign voltages and distance from the source to each node by tracing downstream from the source node
NodeTable[HeadNode[0]][3] = 0.0
NodeTable = AssignNodeVoltages(DG,NodeTable,HeadNode[0],OHLineTable,UGLineTable)


# In SpotLoadTable, add UserDefinedBaseVoltage
for key in SpotLoadTable:
    FromNodeID = SpotLoadTable[key][0]
    # get UserDefinedBaseVoltage for FromNodeID from NodeTable
    UserDefinedBaseVoltage = NodeTable[FromNodeID][0]
    # Set this bus as Load 'L' bus in NodeTable
    NodeTable[FromNodeID][1] = 'L'
    # add this to SpotLoadTable
    SpotLoadTable[key][3] = UserDefinedBaseVoltage
    SpotLoadTable[key][10] = NodeTable[FromNodeID][3] # distance from the source node

# From NodeTable, remove load nodes
### Also do this for PV nodes ###
# make the following more efficient
NodeTable1 = {}
for key in NodeTable:
    if NodeTable[key][1] != 'L' and NodeTable[key][1] != 'g':
        NodeTable1[key] = NodeTable[key]



# make an edge list from graph
OrderedEdgeList=DG.edges()
# create and draw the directed graph using pygraphviz
G1 = pgv.AGraph(strict=False, directed=True)
#ListofEdges = G.edges()
G1.add_edges_from(OrderedEdgeList)

G1.layout(prog='dot')
G1.draw('feeder_tree.pdf')


#**********************************************
# Make a list of buses and branches in the tree
#**********************************************

# make a list of node ids in the tree
TreeNodes = G1.nodes()

# make a list of branch ids in the tree
TreeBranches = []
for i in range(len(OrderedBranchTable)):
     TreeBranches.append(OrderedBranchTable[i][0])


#write to file
print "writing to glm file..."

#create Conductor objects
f.write("//*********************************************\n// Conductor Objects\n//*********************************************\n")
# Write OH Conductor
for key in OHConductorTable:
    CreateOHConductor(f,key,OHConductorTable[key][0],OHConductorTable[key][1],OHConductorTable[key][2])

# Write UG Conductor
for key in UGConductorTable:
    CreateUGConductor(f,key,UGConductorTable[key][0],UGConductorTable[key][1],UGConductorTable[key][2],UGConductorTable[key][3],UGConductorTable[key][4],UGConductorTable[key][5],UGConductorTable[key][6],UGConductorTable[key][7],UGConductorTable[key][8],UGConductorTable[key][9])


#create line spacing objects
f.write("//*********************************************\n// Line spacing objects\n//*********************************************\n")
# Write Line Spacing
for key in LineSpacingTable:
    CreateLineSpacing(f,key,LineSpacingTable[key][0],LineSpacingTable[key][1],LineSpacingTable[key][2],LineSpacingTable[key][3],LineSpacingTable[key][4],LineSpacingTable[key][5],LineSpacingTable[key][6],LineSpacingTable[key][7],LineSpacingTable[key][8],LineSpacingTable[key][9])


#create line configuration objects
f.write("//*********************************************\n// Line Config objects\n//*********************************************\n")
# Write Line config
for key in LineConfigTable:
    CreateLineConfig(f,key,LineConfigTable[key][0],LineConfigTable[key][1],LineConfigTable[key][2],LineConfigTable[key][3],LineConfigTable[key][4])

for key in CableConfigTable:
    CreateLineConfig(f,key,CableConfigTable[key][0],CableConfigTable[key][1],CableConfigTable[key][2],CableConfigTable[key][3],CableConfigTable[key][4])

for key in CableConfigTable_z:
    CreateLineConfig_z(f,key,CableConfigTable_z[key][0],CableConfigTable_z[key][1],CableConfigTable_z[key][2],CableConfigTable_z[key][3])


#create Node objects
f.write("//*********************************************\n// Node Objects\n//*********************************************\n")
# Write nodes
for key in NodeTable1:
    if key in TreeNodes:
        CreateNode(f,key,NodeTable1[key][0],NodeTable1[key][1],NodeTable1[key][2])
        fnodedistance.write(key + "," + str(NodeTable1[key][3]) + "\n")

#create Load objects
f.write("//*********************************************\n// Load Objects\n//*********************************************\n")
f.write("#include \"" + glmfilename + "_loads.glm\"\n\n")
# Write Spot Load
floads.write("#include \"load_schedule.glm\"\n\n")
for key in SpotLoadTable:
    if SpotLoadTable[key][0] in TreeNodes:
        CreateLoad(floads,SpotLoadTable[key][0],SpotLoadTable[key][3],SpotLoadTable[key][1],SpotLoadTable[key][4],SpotLoadTable[key][5],SpotLoadTable[key][6],SpotLoadTable[key][7],SpotLoadTable[key][8],SpotLoadTable[key][9])
        fnodedistance.write(key + "," + str(SpotLoadTable[key][10]) + "\n")

#create Line objects
f.write("//*********************************************\n// Line Objects\n//*********************************************\n")
# Write OH lines
for key in OHLineTable:
    if key in TreeBranches:
        CreateLine(f,OHLineTable[key][3],key,OHLineTable[key][2],OHLineTable[key][4],OHLineTable[key][0],OHLineTable[key][1],OHLineTable[key][5])

# Write UG lines
for key in UGLineTable:
    if key in TreeBranches:
        CreateLine(f,UGLineTable[key][3],key,UGLineTable[key][2],UGLineTable[key][4],UGLineTable[key][0],UGLineTable[key][1],UGLineTable[key][5])

#create Switch objects
f.write("//*********************************************\n// Switch Objects\n//*********************************************\n")
# Write switches
for key in SwitchTable:
    if key in TreeBranches:
        CreateSwitch(f,key,SwitchTable[key][2],SwitchTable[key][0],SwitchTable[key][1],SwitchTable[key][3])


#create Capacitor and regulator objects
#combine them together in _VVO.glm file
f.write("//*********************************************\n// Capacitor and Regulator Objects\n//*********************************************\n")
f.write("#include \"" + glmfilename + "_VVO.glm\"\n\n")

# Write Capacitor objects
fVVO.write("//*********************************************\n// Capacitor Objects\n//*********************************************\n")
for key in ShuntCapTable:
    CreateCapacitor(fVVO,key,ShuntCapTable[key][0],ShuntCapTable[key][1],ShuntCapTable[key][2],ShuntCapTable[key][3],ShuntCapTable[key][4],ShuntCapTable[key][5],ShuntCapTable[key][6],ShuntCapTable[key][7],ShuntCapTable[key][8],ShuntCapTable[key][9],ShuntCapTable[key][10],ShuntCapTable[key][11],ShuntCapTable[key][12],ShuntCapTable[key][13],ShuntCapTable[key][14],ShuntCapTable[key][15],ShuntCapTable[key][16])


# Write Regulator objects
fVVO.write("//*********************************************\n// Regulator Objects\n//*********************************************\n")
#for key in SpotLoadTable:
#    if SpotLoadTable[key][0] in TreeNodes:
#        CreateLoad(floads,SpotLoadTable[key][0],SpotLoadTable[key][3],SpotLoadTable[key][1])


#create Solar, Inverter, Transformer objects
#combine them together in _PV.glm file
f.write("//*********************************************\n// PV Objects\n//*********************************************\n")
f.write("#include \"" + glmfilename + "_PV.glm\"\n\n")

fPV.write("//*********************************************\n// Include the modules\n//*********************************************\n\n")
fPV.write("module climate;\n")
fPV.write("module generators;\n\n")

fPV.write("//*********************************************\n// Climate\n//*********************************************\n\n")
fPV.write("object climate {\n")
fPV.write("    tmyfile \""+tmy2filename+".tmy2\";\n")
fPV.write("}\n\n")

fPV.write("//object csv_reader {\n")
fPV.write("//    name my_csv_reader;\n")
fPV.write("//    filename "+climatecsvfilename+".csv;\n")
fPV.write("//}\n\n")

fPV.write("//object climate {\n")
fPV.write("//    tmyfile "+climatecsvfilename+".csv;\n")
fPV.write("//    reader my_csv_reader;\n")
fPV.write("//}\n\n")

# Write transformer config objects
fPV.write("//*********************************************\n// Transformer config Objects\n//*********************************************\n")
for key in PVTable:
    CreateTransformeConfig(fPV,PVTable[key][18],PVTable[key][19],PVTable[key][20],PVTable[key][21],PVTable[key][15],PVTable[key][16],PVTable[key][22],PVTable[key][23])

# Write transformer objects
fPV.write("//*********************************************\n// Transformer Objects\n//*********************************************\n")
for key in PVTable:
    CreateTransformer(fPV,PVTable[key][17],PVTable[key][8],PVTable[key][14],PVTable[key][7],PVTable[key][18])

# Write triplex meter objects
fPV.write("//*********************************************\n// Triplex meter Objects\n//*********************************************\n")
for key in PVTable:
    CreateTriplexMeter(fPV,PVTable[key][7],PVTable[key][8],PVTable[key][16])

# Write Inverter objects
fPV.write("//*********************************************\n// Inverter Objects\n//*********************************************\n")
for key in PVTable:
    CreateInverter(fPV,PVTable[key][1],PVTable[key][7],PVTable[key][8],PVTable[key][9],PVTable[key][3],PVTable[key][10],PVTable[key][11],PVTable[key][12],PVTable[key][13])

# Write Solar objects
fPV.write("//*********************************************\n// Solar Objects\n//*********************************************\n")
for key in PVTable:
    CreateSolar(fPV,PVTable[key][0],PVTable[key][1],PVTable[key][2],PVTable[key][3],PVTable[key][4],PVTable[key][5],PVTable[key][6])


#CreateTransformeConfig(f,Xfrm_config,Xfrm_connect_type,Xfrm_install_type,Xfrm_power_rating,pri_voltage,sec_voltage,Xfrm_resistance,Xfrm_reactance)
#CreateTransformer(f,XfrmID,InverterPhase,FromNodeID,InverterNodeID,Xfrm_config)
#CreateTriplexMeter(f,InverterNodeID,InverterPhase,sec_voltage)
#CreateInverter(f,InverterID,InverterNodeID,InverterPhase,inverter_mode,generator_status,inverter_type,power_factor,rated_power,inverter_efficiency)
#CreateSolar(f,SolarID,InverterID,generator_mode,generator_status,panel_type,solar_efficiency,solar_area)
#PVTable[PVID] = [SolarID,InverterID,generator_mode,generator_status,panel_type,solar_efficiency,solar_area,InverterNodeID,InverterPhase,inverter_mode,inverter_type,power_factor,rated_power,inverter_efficiency,FromNodeID,pri_voltage,sec_voltage,XfrmID,Xfrm_config,Xfrm_connect_type,Xfrm_install_type,Xfrm_power_rating,Xfrm_resistance,Xfrm_reactance]


#create voltdump object
f.write("//*********************************************\n// voltdump Objects\n//*********************************************\n")
CreateVoltdump(f,"output_voltage.csv","polar")

#create currdump object
f.write("//*********************************************\n// currdump Objects\n//*********************************************\n")
CreateCurrdump(f,"output_current.csv","polar")

#close file
print "closing file..."
f.close()
floads.close()
fnodedistance.close()
fVVO.close()
fPV.close()
#******************************************

