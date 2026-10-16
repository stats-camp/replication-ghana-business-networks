*-------------------------------------------------------------------------
* Purpose: Master file to create the tables and figures from the report
* Inputs: None
* Date: 3/7/2025
*-------------------------------------------------------------------------
set more off
clear all
version 14
set maxvar 32767
set scheme s2color
cap log close

* install packages
ssc install estout
ssc install ftools
ssc install coefplot


* Set username (Change this based on the system username)
* [stats.camp replication] The deposited placeholder `local path "FOLDER"`
* is replaced by the directory this file is run from (the repository
* root), as the instruction above asks each replicator to do. See README.md.
local path "`c(pwd)'"

* Set adopath for ado-file	
adopath + "`path'"

* Set paths for the code/data/output
global replication "`path'"


*** Create empty directories if not downloaded ***
capture mkdir "${replication}/data/analysis"
capture mkdir "${replication}/log"
capture mkdir "${replication}/output/figures"
capture mkdir "${replication}/output/tables"


global code "${replication}/code"
global data "${replication}/data"
global logfile "${replication}/log"
global output_figures "${replication}/output/figures"
global output_tables "${replication}/output/tables"

* Log files to print output
log using "${logfile}/gender_gaps_ghana_code_log.txt",replace
* Switches 
local clean = 1    // clean
local output = 1   // output

if `clean' == 1 {
    do "${code}/clean.do" 
}
if `output' == 1 {
    do "${code}/output.do" 
}

