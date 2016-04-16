[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.15629.svg)](http://dx.doi.org/10.5281/zenodo.15629)
OpenABR
======

The OpenABR system is for aiding auditory scientists with their research. It provides consistent and objective ABR analysis, easy storage and retrieval, simple querying, graphing and export. OpenABR has been designed from the ground up to accept different ABR data formats and integrate with existing recoding setups.
The system comprises a web-interface, server and database. The web-interface is used for uploading files, browsing the data, analysing and exporting. The server can be accessed via its API to automatically upload ABR data. Data is organised by Subject as well as Experiment, tags or any other meta-data.
OpenABR uses Bogaerts, et al (2009) method for ABR set threshold detection with a configurable standard deviation level. The system still allows manual threshold selection if so desired.
Waveform peak marking is not automated, however a interface is provided to vastly speed up the process. Exportable results include peak-to-peak latencies and amplitudes.

Server Requirements
============

 - [CouchDB](http://couchdb.apache.org/) v1.6 or greater (Windows, Linux or Mac)
 - [Nodejs](https://nodejs.org/) v5.10 or greater (Windows, Linux or Mac)

Installation
============

 - Install [CouchDB](http://couchdb.apache.org/) and ensure it is in a 'Admin Party'.
 - Install [Nodejs](http://nodejs.org/) and ensure running `node --version` gives a version greater than `5.10.x`.
 - Install the program files from a package, or clone the github repository into an application folder.
 - Run `npm install` to pull and install all project dependencies (requires internet connection).
 - Verify that `config\defaults.yaml` details for your CouchDB installation are correct.
   - If you have already set up a admin user for CouchDB enter the details here so `openabr` can be deployed.
   - If you are installing the `proxy` on a different server you will need to ensure that `host` and `port` match this.
 - Run 'gulp deploy' to install the application to CouchDB.
   - If you don't want to use the default database names you can change them in the `default.yaml` configuration file - but remember to update the `proxy` targets.
   - This will create an administration account if it dosen't already exist, please take note of the password as it is needed to manage/upgrade OpenABR.
   - Once complete you can browse CouchDB to ensure that two databases have been created each with a `_design` document containing the applications.
 - You will now need to setup the `proxy` service to forward to the correct application endpoints
   - `node proxy` will run the provided proxy and use the configuration in `default.yaml`
     - As a permanent solution you can use a node process manager like [PM2](http://github.com/Unitech/pm2) to monitor, restart and mangage the proxy process.
   - If you want to use your own proxy then you will need to implement the rules in `proxy.js`

For Developers
==============

 - User-portal and Admin-portal are both Single Page applications build using [CoffeeScript](http://coffeescript.org/), [AmpersandJS](https://ampersandjs.com/) and [Webpack](https://webpack.github.io/).
   - They are *not* `CouchApp` projects, but are similar.
 - Data persistence, user management, and validation is provided by CouchDB.
   - We use a `_design` document in each application
   - We also use a `_security` document in each application
   - Users are managed by CouchDB using `cookie` authentication

Extending OpenABR / New Features
================================
 - Any proposal is always welcome, feel free to create an [issue](https://github.com/daskurka/openabr/issues) for new features, bugs or even related discussions.
 - If you want to contribute to this project or anything more then get in touch I welcome all.
 - Its open source of course, you can just modify it yourself, for yourself.
