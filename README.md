[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.15629.svg)](http://dx.doi.org/10.5281/zenodo.15629)
OpenABR
======

The OpenABR system is for aiding auditory scientists with their research. It provides consistent and objective ABR analysis, easy storage and retrieval, simple querying, graphing and export. OpenABR has been designed from the ground up to accept different ABR data formats and integrate with existing recoding setups.
The system comprises a web-interface, server and database. The web-interface is used for uploading files, browsing the data, analysing and exporting. The server can be accessed via its API to automatically upload ABR data. Data is organised by Subject as well as Experiment, tags or any other meta-data.
OpenABR uses Bogaerts, et al (2009) method for ABR set threshold detection with a configurable standard deviation level. The system still allows manual threshold selection if so desired.
Waveform peak marking is not automated, however a interface is provided to vastly speed up the process. Exportable results include peak-to-peak latencies and amplitudes.

Requirements
============

 - CouchDB 1.6 or greater.
 - A proxy such as [HAProxy](http://www.haproxy.org/)
 - Nodejs (Windows, Linux or Mac are all fine) for deployment/upgrade of the application (dosen't have to be on same machine as CouchDB / Proxy).

Installation
============

 - Install CouchDB and ensure it is in a 'Admin Party'.
 - Run `npm install` to pull all project dependencies.
 - Run 'gulp deploy {host}' where `{host}` is host and port of the CouchDB installation, i.e. `http://localhost:5984`.
   - This will create an `architect` administration account, please take note of the password, it is used to manage users.
 - Install and configure a 'reverse proxy' to forward two the three CouchDB endpoints.
   - Application expects to be at root `/` must be forwarded too `http://localhost:5984/openabr/_design/app/_rewrite`.
   - Administration expects to be at `/admin` must be forwarded too `http://localhost:5984/openabr-admin/_design/admin/_rewrite`.
   - For authentication `/login` must be forwarded too `http://localhost:5984/openabr-login/_design/login/_rewrite`.
   - For example: proxy should forward from `/user/account` to `/openabr/_design/app/_rewrite/user/account`.

For Developers
==============

 - Main application user interface is a Single Page Application build using CoffeeScript, AmpersandJS and Webpack.
 - Login and Admin applications are both simple fixed HTML and CSS implementations.
 - Data persistence, user management, and validation is provided by CouchDB.
 - This is *not* a CouchApp project, but makes use of many similar concepts.
