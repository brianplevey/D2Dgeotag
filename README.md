D2D Project Geolocation Tasks
=========


The following scripts are used for various tasks:
**events.R** read in events data from multiple files
**gadm.R** read in shape files
**calais.R** read in calais output
**hugo.R** read in hugo output
**merge.R** merge all data
**grade.R** prepare file for testing / training grading
**paragraph.R** merge full paragraphs or stories to grading (optional)
**locate.R** review graded geotagged events and model the final geotags

# File Structure
* D2D
  * data
    * calais
	  * *country folders*
	    * *calais geotags*
	* events
	  * *country folders*
	* gadm
	* geonames
	* grading
	* gtds
	* hugo
	  * *country folders*
	    * *dictionaries*
		* *input files*
		* *output files*
	* *working datasets*
  * figures
  * geotag
    * *geotagging scripts*
  * models
  