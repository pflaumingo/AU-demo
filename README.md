# Introduction
This repository serves as a living source to get users started with customizing Systems Analysis for their needs. 
It includes various useful links to resources to learn about the Systems Analysis Workflow from the UI, to understand
OpenStudio and how Measures and Workflows work, as well as pointers to EnergyPlus documentation and so on.

# Revit Systems Analysis UI Workflow
As a first step to learning Systems Analysis, the following videos should be viewed:
 - Webinar by Ian Molloy, Autodesk Senior Product Manager: [An Introduction to Revit Systems Analysis](https://www.youtube.com/watch?v=8kvSB5abVH4)
 - AU Class by Ian Molloy: [Revit Systems Analysis Features and Framework: An Introduction] (Update with future link)
 - Autodesk Knowledge Network: [Systems Analysis](https://knowledge.autodesk.com/support/revit-products/learn-explore/caas/CloudHelp/cloudhelp/2020/ENU/Revit-Analyze/files/GUID-A262F53F-B389-4846-89EF-5855F55476A5-htm.html)
   - The "Heating and Cooling Loads Analysis" section is a different product that should not be confused with Systems Analysis

# gbXML
gbXML is simply an xml file conforming to the gbXML schema that Revit writes all of the pertinent analysis information to.
OpenStudio then consumes the gbXML to generate the EnergyPlus model. The schema can be found [here](http://www.gbxml.org/schema_doc/6.01/GreenBuildingXML_Ver6.01.html)

# EnergyPlus
EnergyPlus is a Building Energy Modeling (BEM) engine used for both sizing equipment and performing various analyses such
as annual energy consumption prediction. More information can be found at it's webpage [here](https://energyplus.net/), 
as well as the most recent documentation [here](https://energyplus.net/documentation). The EnergyPlus input file, is a
text file known as IDF and it is unlikely users will work with it directly in the Systems Analysis workflow. That said,
if users want to gain an appreciation for working with EnergyPlus directly and for the hard work OpenStudio does for them,
then they should considering going through the getting started guide. Moreover, the Engineering Reference and Input Output
Reference help give users a greater understanding of what the inputs do (i.e. how controls work). Finally, the Output
Details and Examples section of the documentation provides further information on what data is available from the 
simulation outputs.

# OpenStudio
OpenStudio is a collection of software tools focused on building and orchestrating EnergyPlus simulations more easily.
OpenStudio contains extensive [User Documentation](https://nrel.github.io/OpenStudio-user-documentation/) highlighting
how to get started with OpenStudio, and [SDK Documentation](https://openstudio-sdk-documentation.s3.amazonaws.com/index.html)
to make navigating the API easier. I strongly suggest reading the [About Measures](https://nrel.github.io/OpenStudio-user-documentation/getting_started/about_measures/)
section, creating a ["Hello, World!" Measure](https://nrel.github.io/OpenStudio-user-documentation/reference/measure_writing_guide/)
tutorial and, given that Systems Analysis uses OpenStudio Workflows, you should read up on the 
[OpenStudio Command Line Interace](https://nrel.github.io/OpenStudio-user-documentation/reference/command_line_interface/).
The OSW Structure sub section will be of most relevance, but feel free to read the entire page.

## Additional OpenStudio Projects
 - There is the [Parametric Analysis Tool (PAT)](https://nrel.github.io/OpenStudio-user-documentation/reference/parametric_studies/)
and [OpenStudio-server](https://nrel.github.io/OpenStudio-user-documentation/tutorials/large_scale_analysis/) that allow
users to run batches of simulations locally and in the cloud.
 - The OpenStudio Standards is a ruby gem (library) that makes generating typical buildings and systems easier, as well
 as providing baseline automation for some Standards (i.e. various versions of ASHRAE 90.1). You can read about it 
 [here] (future link)
 - The [Building Component Library](bcl.nrel.gov) is an online repository of Measures and and OpenStudio Components with a tutorial on
 how to use it available [here](https://nrel.github.io/OpenStudio-user-documentation/tutorials/tutorial_bcl/). It's a good
 resource for looking at other Measures people have built and made public to help you craft your own.


# Customizing Systems Analysis
The first step in customizing Systems Analysis should be to watch the following AU class: [Creating Custom Workflows](Update with future link).
It will highlight the Systems Analysis Framework and give you an understand of all the components involved and the end-to-end data
flow from Revit through simulation and back again. It will also walk you through a few "Hello, World!" type of customizations that you
should be able to recreate with the material from this repo.


