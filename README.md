# Introduction
This repository serves as a living source to get users started with customizing Systems Analysis for their needs. 
It includes various useful links to resources to learn about the Systems Analysis Workflow from the UI, to understand
OpenStudio and how Measures and Workflows work, as well as pointers to EnergyPlus documentation and so on.

# Revit Systems Analysis UI Workflow
As a first step to learning Systems Analysis, the following videos should be viewed:
 - Webinar by Ian Molloy, Autodesk Senior Product Manager: [An Introduction to Revit Systems Analysis](https://www.youtube.com/watch?v=8kvSB5abVH4)
 - AU Class by Ian Molloy: [Revit Systems Analysis Features and Framework: An Introduction](www.google.com)
 - Autodesk Knowledge Network: [Systems Analysis](https://knowledge.autodesk.com/support/revit-products/learn-explore/caas/CloudHelp/cloudhelp/2020/ENU/Revit-Analyze/files/GUID-A262F53F-B389-4846-89EF-5855F55476A5-htm.html)
   - The "Heating and Cooling Loads Analysis" section is a different product that should not be confused with Systems Analysis

# gbXML
gbXML is simply an xml file conforming to the gbXML schema that Revit writes all of the pertinent analysis information to
that OpenStudio then consumes to generate the EnergyPlus model. The schema can be found [here](http://www.gbxml.org/schema_doc/6.01/GreenBuildingXML_Ver6.01.html)

# EnergyPlus


# Customizing Systems Analysis
The first step in customizing Systems Analysis should be to watch the following AU class: [Creating Custom Workflows](www.google.com).
It will highlight the Systems Analysis Framework and give you an understand of all the components involved and the end-to-end data
flow from Revit through simulation and back again. It will also walk you through a few "Hello, World!" type of customizations that you
should be able to recreate with the material from this repo.


