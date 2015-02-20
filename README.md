OpenABR
======

The OpenABR system is for aiding auditory scientists with their research. It provides consistent and objective ABR analysis, easy storage and retrieval, simple querying, graphing and export. OpenABR has been designed from the ground up to accept different ABR data formats and integrate with existing recoding setups.
The system comprises a web-interface, server and database. The web-interface is used for uploading files, browsing the data, analysing and exporting. The server can be accessed via its API to automatically upload ABR data. Data is organised by Subject as well as Experiment, tags or any other meta-data.
OpenABR uses Bogaerts, et al (2009) method for ABR set threshold detection with a configurable standard deviation level. The system still allows manual threshold selection if so desired.
Waveform peak marking is not automated, however a interface is provided to vastly speed up the process. Exportable results include peak-to-peak latencies and amplitudes.

Requirements
============

Requires Nodejs running on a computer (Windows, Linux or Mac are all fine).
Requires MongoDB server (local or networked).

Installation
============
TBC


For Developers
==============

Implemented using CoffeeScript (full stack), Jade for templating, Mongoose for MongoDB persistence. Front end is an AmpersandJS Single Page App. Moonboots is used to serve app and resources.