#Purpose 

To accelerate research and decision making data needs to be findable, accessible, interoperable, and reusable (FAIR). Multiple federal, state and tribal agencies collect in-stream and riparian habitat metrics to answer management questions specific to their program goals. 

The Aquatic Habitat Analysis package will integrate aquatic habitat data from multiple projects to provide access and analysis of aquatic habitat data status and trend across jurisdictions.  We will provide an analysis package to analyze the status and trends and threshold exceedance for in-stream and riparian habitat metrics based on user’s inputs and access to downloadable data with associated environmental covariates, and metadata for aquatic habitat programs’ data.


As a proof of concept for this analysis package, I want to pick 2-3 metrics as a test case to build a data dictionary and design the analysis package infrastructure.  I selected metrics that demonstrate the impact of management decisions, have low measure error (Kershner and Roper 2010 ) and the according to the BLM AIM PROTOCOL, PROTOCOL SHOOTOUT field collection methods are considered comparable between at least 3 of the monitoring programs.

This package will help answer management questions for in-stream and riparian habitat such as:  
What is the status and trend of aquatic ecosystems based on user defined HUC, State, Forest, BLM Management unit or Tribal boundaries? 
Determine if aquatic systems are being degraded, maintained or restored, based on disturbance and determine the direction and rate of changes in riparian and aquatic habitat over time? (Figure 1)   (CITE PIBO WEBPAGE) 


Figure 1) Example of analysis for the trend of aquatic metric based on management type (CITE PIBO REPORT) 

The quality in-stream habitat will achieve or exceed federal, state, tribal threshold standards for water quality? (CITE BLM REPORT) 
 
Additional benefits for data users: 
Summary analysis based on user defined spatial and temporal extent to be used in products such as Forest Plans, Annual Reports, BLM Grazing permits 
Access to organized aquatic habitat metrics and indicators and environmental covariates across projects. Potential users Including the National Fish Habitat Monitoring Partnership and Dreissenid Mussel Risk Assessments Working Group. 
Standard FGDC (ISO) metadata based on users’ download criteria
Benefits for the data providers include: 
Increase visibility and data reuse of long term, large spatial scale in-stream and upland riparian habitat monitoring data 
Streamline data publishing and access to long term datasets, freeing up data manager’s time 
Provide interactive summary analysis for spatial regions such as forests, BLM regions, states and tribal holdings answering basic management question, allowing project’s data analysts to focus on novel analysis 
Benefits for National Monitoring Framework (NMF): 
Leverage existing capacities to answer management questions for specific audiences, using resources such as BLM’s AIM database, EPA’s Water Quality Portal, USGS’ ScienceBase, StreamStats, Metadata Generator, and MonitoringResources.org. 
Improve access to in-stream and riparian habitat data, analysis, and metadata. 
Example of USGS leading efforts to share resources across agencies inside DOI (USGS and BLM) and outside the DOI (USFS)
Working across Mission Areas in the USGS to expand knowledge and produce FAIR data products 

Inputs
To scale this project to 120 day detail I recommend focusing on data that is already available via APIs, the BLM AIM Aquatic Habitat Data and the EPA National Rivers and Streams Data and focusing on metrics and indicators that are compatible based on expert opinion and the  AIM National Aquatic Monitoring Framework Technical Reference 1735-2 Appendix A: Protocol Compatibility (INSERT REFERENCE) 

BLM AIM Aquatic Habitat Data- BLM Aquatic AIM provides in-stream and riparian habitat metrics, indicators and progrect metadata. 
Aquatic AIM Lead, Scott Miller, swmiller@blm.gov
Spatial Extent- BLM lands across the western United States from the Dakota’s West and includes Alaska. 
Temporal Extent: ?-2019
Data- https://landscape.blm.gov/geoportal/catalog/AIM/AIM.page
Metadata- https://aim.landscapetoolbox.org/introduction-to-aim/
EPA National Rivers and Streams 
NAME 
Spatial Extent
Temporal Extent 
Data- Water Quality Portal 
Metadata 
PackFish/InFish Biological Open Effectiveness Monitoring (PIBO-EM)  - PIBO EM provides in-stream and riparian habitat metries, indicators and project metadata. 
PIBO Em Lead, Carl Sanders 
Spatial Extent- Upper Columbia and Missouri River Basins
Temporal Extent
Data- Data is not published 
Metadata- 
AREMP - AREMP provides in-stream and riparian habitat metrics, indicators and project metadata
MonitoringResources.org 
Description - MonitoringResources.org is detailed metadata documentation. MR.org will provide method definitions to allow user to assess compatibility between methodology. 
MR.org project lead, Becca Scully, rscully@usgs.gov 
Spatial Extent - NA
Temporal Extent - NA 
Data www.monitoringresources.org 
Environmental covariates (selected based on https://afspubs.onlinelibrary.wiley.com/doi/pdf/10.1577/T08-221.1) 
Need to look into StreamStats for calculating the same environmental covariates for all data collection events (Also TauDEM GIS package) 
Area= Catchment Area
Precip= average annual precipitation
Drainage density= density of stream with in the catchment 
Dominant geology (Sedimentary, igneous) 
Gradient= reach gradient 
Elevation = Elevation of the bottom of the reach 
 
 
 
Outputs
Document all outputs. Again names, links, security constraints, spatial extent and resolution, temporal extent and resolution, example output code all help speed development and ensure repeatability. We'll also need this for the review(s).

Napkin Drawing 

 


Constraints
List and adequately explain any analytical constraints. For example, is the analysis only appropriate at a certain scale? Are there temporal aspects that must be met for a valid analysis? What conditions need to be met before performing a given analysis?

Dependencies
List all dependencies. Are there specific software libraries, packages, or other BAPs that are required to do this analysis? If so, what are they called, where can they be found and what version did you use? All this will also be wrapped up in the provenance trace.

Code
Where is your code? It needs to be under source control in a publicly accessible repository. Most of us use GitHub for our development but that choice is yours. Note the official USGS repos are required for disseminating final, authorized for release code. What is your code written in? R? Python? We use both for the science code and a mix for operational. Note, for sanity we always try to code against APIs and standards (e.g. W3C and OGC). It is a simple best practice. Plus, we tend to capture much of this in Jupyter notebooks under source control that we can share and collaborate on.

Tests
Tests for BAPs are both conceptual and technical. A core principle we are pursuing in the BAP quest is the idea of a logical test for the applicability of what the BAP does with an appropriate stakeholder. At this stage of our development, we need to make sure that the BAPs we are spending time on can be directly applied to resource management or policymaking decision analysis. A key element of documenting a BAP is figuring out what this use may be and designing an engagement plan for testing and incorporating results into future work.
Also consider baking technical tests into the code part of a BAP. This is really important when we toss things to the developers. We are the domain experts. And since we have captured the previous five things, we need to communicate what the answers are to the folks that grab our science code and make it live. While they have broad and diverse experience working in this area, they may not know what the "right" answer looks like. We need to give them examples to work with and build from.

Provenance
Provenance is required. This is built into the system. Several of the previous items feed into that integral subsystem, so this will not be a difficult requirement to meet. We follow W3C PROV closely.

Citations
We need them. Just as for your papers, citations provide the scholarly basis for your choice of methodology and implementation, and, given the reusable requirement, provide the background users need to understand and use your BAP for their own work.
All of this information will be made available for the review processes. There are at least three of them. Two of these, the daily ongoing and the internal, are informal and involve working with your branch and program colleagues. The two BAPs we talked about, the ones at https://maps.usgs.gov/biogeography, have gone through both of these informal reviews. The other BAPs currently in development are queueing up for the internal. Every BAP will go through the appropriate level of formal review before it is authorized for official release.
