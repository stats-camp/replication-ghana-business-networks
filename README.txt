Package documentation adapted for stats.camp.

README
Data and Code for: Gender Gaps in Entrepreneurship: Business Networks and
Collaborations in Ghana
Monica Lambon-Quayefio, Edward Asiedu, Francesca Truffa, and Ashley Wong

Overview
The code in this replication package constructs the analysis file in stats.camp. Three main
files run all the code to generate the data for the 2 figures and 3 tables in the paper. The
replicator should expect the code to run for about 5-10 minutes.

Data Availability and Provenance Statements
Statement about Rights
•    I certify that the author(s) of the manuscript have legitimate access to and
     permission to use the data used in this manuscript.
•   I certify that the author(s) of the manuscript have documented permission to
    redistribute/publish the data contained within this replication package.
Summary of Availability
•  All data are publicly available.

Details on each Data Source
 Data.Name               Data.Files            Location  Provided Citation
 Survey of               gender_gaps_ghana.dta data/raw/ TRUE     Lambon-
 agribusinesses in                                                Quayefio et al.
 Ghana                                                            (2025)

Survey data
    The survey data of agribusinesses in Ghana was collected by the authors on a
    sample of male and female entrepreneurs in the agribusiness sector in Ghana who
    have applied to or participated in a training program oﬀered by the Ghana
    National Entrepreneurship Innovation Programme (NEIP). This data have been
    deposited in the AEA Data and Code repository
    (https://doi.org/10.3886/E228101V1). The data were collected by the authors,
    and are available under a Creative Commons Non-commercial license.

Computational requirements
Software Requirements
Run the package in stats.camp. The required estout and coefplot commands are
provided by the engine, and zindex.ado is included in this package. The master
script prepares the directory structure and runs the analysis scripts.

Memory, Runtime, Storage Requirements

Summary
Approximate time needed to reproduce the analyses on a standard 2025 desktop machine:
•   <10 minutes

Approximate storage space needed:
•   < 25 MBytes

Instructions to Replicators
•   To execute all analyses, simply run the master.do file, ensuring that the necessary
    paths are correctly set and the switches for clean and output are set to 1. Below is an
    overview of the functions of other code files in the folder:
      –    clean.do: This file renames and generates dummy variables for the analysis. It
           also creates the index variables using zindex.ado. Lastly, it saves the cleaned
           dataset under data/analysis as gender_gaps_ghana_clean.dta.

      –    output.do: This file uses gender_gaps_ghana_clean.dta to create Tables
           1,2 and 3 and Figure 1.

Instructions to Replicators
•   Run code/master.do from the package root to run all steps in sequence.
    The adapted master script resolves its paths from the working directory.

References
Lambon-Quayefio, Monica, Edward Asiedu, Francesca Truffa, and Ashley Wong. 2025. “Data and
Code for: Gender Gaps in Entrepreneurship: Business Networks and Collaborations in Ghana.”
American Economic Association, Inter-university Consortium for Political and Social Research, AEA
Data and Code Repository https://doi.org/10.3886/E228101V1
