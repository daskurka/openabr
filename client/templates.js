(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        define([], factory);
    } else if (typeof exports === 'object') {
        module.exports = factory();
    } else if (typeof root === 'undefined' || root !== Object(root)) {
        throw new Error('templatizer: window does not exist or is not an object');
    } else {
        root.templatizer = factory();
    }
}(this, function () {
    var jade=function(){function e(e){return null!=e&&""!==e}function n(t){return(Array.isArray(t)?t.map(n):t&&"object"==typeof t?Object.keys(t).filter(function(e){return t[e]}):[t]).filter(e).join(" ")}var t={};return t.merge=function r(n,t){if(1===arguments.length){for(var a=n[0],i=1;i<n.length;i++)a=r(a,n[i]);return a}var o=n["class"],s=t["class"];(o||s)&&(o=o||[],s=s||[],Array.isArray(o)||(o=[o]),Array.isArray(s)||(s=[s]),n["class"]=o.concat(s).filter(e));for(var l in t)"class"!=l&&(n[l]=t[l]);return n},t.joinClasses=n,t.cls=function(e,r){for(var a=[],i=0;i<e.length;i++)a.push(r&&r[i]?t.escape(n([e[i]])):n(e[i]));var o=n(a);return o.length?' class="'+o+'"':""},t.style=function(e){return e&&"object"==typeof e?Object.keys(e).map(function(n){return n+":"+e[n]}).join(";"):e},t.attr=function(e,n,r,a){return"style"===e&&(n=t.style(n)),"boolean"==typeof n||null==n?n?" "+(a?e:e+'="'+e+'"'):"":0==e.indexOf("data")&&"string"!=typeof n?(-1!==JSON.stringify(n).indexOf("&")&&console.warn("Since Jade 2.0.0, ampersands (`&`) in data attributes will be escaped to `&amp;`"),n&&"function"==typeof n.toISOString&&console.warn("Jade will eliminate the double quotes around dates in ISO form after 2.0.0")," "+e+"='"+JSON.stringify(n).replace(/'/g,"&apos;")+"'"):r?(n&&"function"==typeof n.toISOString&&console.warn("Jade will stringify dates in ISO form after 2.0.0")," "+e+'="'+t.escape(n)+'"'):(n&&"function"==typeof n.toISOString&&console.warn("Jade will stringify dates in ISO form after 2.0.0")," "+e+'="'+n+'"')},t.attrs=function(e,r){var a=[],i=Object.keys(e);if(i.length)for(var o=0;o<i.length;++o){var s=i[o],l=e[s];"class"==s?(l=n(l))&&a.push(" "+s+'="'+l+'"'):a.push(t.attr(s,l,!1,r))}return a.join("")},t.escape=function(e){var n=String(e).replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;");return n===""+e?e:n},t.rethrow=function a(e,n,t,r){if(!(e instanceof Error))throw e;if(!("undefined"==typeof window&&n||r))throw e.message+=" on line "+t,e;try{r=r||require("fs").readFileSync(n,"utf8")}catch(i){a(e,null,t)}var o=3,s=r.split("\n"),l=Math.max(t-o,0),f=Math.min(s.length,t+o),o=s.slice(l,f).map(function(e,n){var r=n+l+1;return(r==t?"  > ":"    ")+r+"| "+e}).join("\n");throw e.path=n,e.message=(n||"Jade")+":"+t+"\n"+o+"\n\n"+e.message,e},t}();

    var templatizer = {};
    templatizer["includes"] = {};
    templatizer["pages"] = {};
    templatizer["views"] = {};
    templatizer["includes"]["form"] = {};
    templatizer["includes"]["items"] = {};
    templatizer["includes"]["navbar"] = {};
    templatizer["pages"]["admin"] = {};
    templatizer["pages"]["experiments"] = {};
    templatizer["pages"]["profile"] = {};
    templatizer["pages"]["query"] = {};
    templatizer["pages"]["subjects"] = {};
    templatizer["pages"]["upload"] = {};
    templatizer["views"]["abrGroups"] = {};
    templatizer["views"]["abrReadings"] = {};
    templatizer["views"]["abrSets"] = {};
    templatizer["views"]["analysis"] = {};
    templatizer["views"]["experiments"] = {};
    templatizer["views"]["graphs"] = {};
    templatizer["views"]["subjects"] = {};
    templatizer["views"]["upload"] = {};
    templatizer["pages"]["admin"]["fields"] = {};
    templatizer["pages"]["admin"]["users"] = {};
    templatizer["views"]["graphs"]["latency"] = {};
    templatizer["views"]["graphs"]["threshold"] = {};

    // body.jade compiled template
    templatizer["body"] = function tmpl_body() {
        return '<body><div class="navbar-container"></div><div class="container"><main data-hook="page-container"></main></div></body>';
    };

    // head.jade compiled template
    templatizer["head"] = function tmpl_head() {
        return '<meta charset="utf-8"/><meta http-equiv="X-UA-Compatible" content="IE=edge"/><meta name="viewport" content="width=device-width, initial-scale=1"/><meta name="description" content="OpenABR Site"/><meta name="author" content="Sam Kirkpatrick"/><link rel="icon" href="/img/favicon.ico"/><title>OpenABR</title>';
    };

    // includes\confirm.jade compiled template
    templatizer["includes"]["confirm"] = function tmpl_includes_confirm() {
        return '<div class="confirmButton"><div data-hook="main-section" style="" class="mainSection"><button data-hook="main-button" type="button" style="width: 140px;" class="btn btn-primary"></button>&nbsp;&nbsp;<span data-hook="main-message"></span></div><div data-hook="confirm-section" style="" class="confirmSection"><div class="confirmMessage"><div class="btn-group"><button data-hook="confirm-button" type="button" style="width: 70px;" class="btn btn-warning">Confirm</button><button data-hook="cancel-button" type="button" style="width: 70px;" class="btn btn-default">Cancel</button></div>&nbsp;&nbsp;<span data-hook="confirm-message"></span></div></div></div>';
    };

    // includes\form\checkbox.jade compiled template
    templatizer["includes"]["form"]["checkbox"] = function tmpl_includes_form_checkbox() {
        return '<div class="form-group"><label data-hook="label"></label><input type="checkbox" class="form-control"/><div data-hook="message-container"><div data-hook="message-text" class="alert alert-danger"></div></div></div>';
    };

    // includes\form\input.jade compiled template
    templatizer["includes"]["form"]["input"] = function tmpl_includes_form_input() {
        return '<div class="form-group"><label data-hook="label"></label><div data-hook="message-container"><div data-hook="message-text" class="alert alert-danger"></div></div><input class="form-control"/></div>';
    };

    // includes\form\number.jade compiled template
    templatizer["includes"]["form"]["number"] = function tmpl_includes_form_number() {
        return '<div class="form-group"><label data-hook="label"></label><div data-hook="message-container"><div data-hook="message-text" class="alert alert-danger"></div></div><div class="row"><div class="col-sm-11"><input step="any" class="form-control"/></div><div class="col-sm-1"><div data-hook="unit-prefix" class="numberUnitAndPrefix"></div></div></div></div>';
    };

    // includes\form\password.jade compiled template
    templatizer["includes"]["form"]["password"] = function tmpl_includes_form_password() {
        return '<div class="form-group"><label data-hook="label"></label><div data-hook="message-container"><div data-hook="message-text" class="alert alert-danger"></div></div><input data-hook="password-input" type="password" class="form-control"/><label data-hook="label-confirm"></label><input data-hook="password-input-confirm" type="password" class="form-control"/></div>';
    };

    // includes\form\select.jade compiled template
    templatizer["includes"]["form"]["select"] = function tmpl_includes_form_select() {
        return '<div class="form-group select"><label data-hook="label"></label><div data-hook="message-container"><div data-hook="message-text" class="alert alert-danger"></div></div><select class="form-control"></select></div>';
    };

    // includes\form\users.jade compiled template
    templatizer["includes"]["form"]["users"] = function tmpl_includes_form_users() {
        return '<div class="form-group"><label data-hook="label"></label><div data-hook="message-container"><div data-hook="message-text" class="alert alert-danger"></div></div><input class="form-control"/></div>';
    };

    // includes\items\dataField.jade compiled template
    templatizer["includes"]["items"]["dataField"] = function tmpl_includes_items_dataField() {
        return '<tr data-hook="field-row"><td data-hook="name"></td><td data-hook="type"></td><td data-hook="dbName"></td><td><span data-hook="required" class="glyphicon glyphicon-ok"></span></td><td><span data-hook="autoPop" class="glyphicon glyphicon-ok"></span></td><td data-hook="creator"></td><td data-hook="description"></td></tr>';
    };

    // includes\items\detailListItem.jade compiled template
    templatizer["includes"]["items"]["detailListItem"] = function tmpl_includes_items_detailListItem(locals) {
        var buf = [];
        var jade_mixins = {};
        var jade_interp;
        var locals_for_with = locals || {};
        (function(formattedNumber, model, researcher) {
            buf.push("<tr>");
            if (model.type == "string") {
                buf.push('<td align="right"><strong>' + jade.escape(null == (jade_interp = model.name) ? "" : jade_interp) + "</strong></td><td>" + jade.escape(null == (jade_interp = model.value) ? "" : jade_interp) + "</td>");
            } else if (model.type == "number") {
                buf.push('<td align="right"><strong>' + jade.escape(null == (jade_interp = model.name) ? "" : jade_interp) + "</strong></td><td>" + jade.escape(null == (jade_interp = formattedNumber) ? "" : jade_interp) + "</td>");
            } else if (model.type == "date") {
                buf.push('<td align="right"><strong>' + jade.escape(null == (jade_interp = model.name) ? "" : jade_interp) + "</strong></td>");
                if (model.value == null || model.value.getTime() == 0) {
                    buf.push("<td>—</td>");
                } else {
                    buf.push("<td>" + jade.escape(null == (jade_interp = model.value.toISOString().split("T")[0]) ? "" : jade_interp) + "</td>");
                }
            } else if (model.type == "user") {
                buf.push('<td align="right"><strong>' + jade.escape(null == (jade_interp = model.name) ? "" : jade_interp) + "</strong></td><td>" + jade.escape(null == (jade_interp = researcher) ? "" : jade_interp) + "</td>");
            } else {
                buf.push('<td align="right"><strong>' + jade.escape(null == (jade_interp = model.name) ? "" : jade_interp) + "</strong></td><td>" + jade.escape(null == (jade_interp = model.value) ? "" : jade_interp) + "</td>");
            }
            buf.push("</tr>");
        }).call(this, "formattedNumber" in locals_for_with ? locals_for_with.formattedNumber : typeof formattedNumber !== "undefined" ? formattedNumber : undefined, "model" in locals_for_with ? locals_for_with.model : typeof model !== "undefined" ? model : undefined, "researcher" in locals_for_with ? locals_for_with.researcher : typeof researcher !== "undefined" ? researcher : undefined);
        return buf.join("");
    };

    // includes\items\emptyRowView.jade compiled template
    templatizer["includes"]["items"]["emptyRowView"] = function tmpl_includes_items_emptyRowView() {
        return "<tr>No records found...</tr>";
    };

    // includes\items\fixedDataField.jade compiled template
    templatizer["includes"]["items"]["fixedDataField"] = function tmpl_includes_items_fixedDataField() {
        return '<tr data-hook="fixed-field-row"><td data-hook="name"></td><td data-hook="type"></td><td data-hook="dbName"></td><td><span data-hook="required" class="glyphicon glyphicon-ok"></span></td><td><span data-hook="autoPop" class="glyphicon glyphicon-ok"></span></td><td data-hook="description"></td></tr>';
    };

    // includes\items\user.jade compiled template
    templatizer["includes"]["items"]["user"] = function tmpl_includes_items_user() {
        return '<tr data-hook="user-row"><td data-hook="name"></td><td data-hook="email"></td><td data-hook="position"></td></tr>';
    };

    // includes\navbar\loggedin.jade compiled template
    templatizer["includes"]["navbar"]["loggedin"] = function tmpl_includes_navbar_loggedin(locals) {
        var buf = [];
        var jade_mixins = {};
        var jade_interp;
        var locals_for_with = locals || {};
        (function(isAdmin, user) {
            buf.push('<div class="navbar-header"><a href="/" class="navbar-brand">OpenABR</a></div><ul class="nav navbar-nav"><li><a href="/upload">Upload ABR</a></li><li><a href="/query/readings">Query ABRs</a></li><li><a href="/experiments">Experiments</a></li><li><a href="/subjects">Subjects</a></li></ul><ul class="nav navbar-nav navbar-right">');
            if (isAdmin) {
                buf.push('<li class="dropdown"><a href="#" data-toggle="dropdown" class="dropdown-toggle">Admin&nbsp;<span class="caret"></span></a><ul role="menu" class="dropdown-menu"><li><a href="/admin/users">Users</a></li><li><a href="/admin/fields">Fields</a></li></ul></li>');
            }
            buf.push('<li><a href="/logout">Logout</a></li></ul><p class="navbar-text navbar-right"><a href="/profile">' + jade.escape((jade_interp = user.name) == null ? "" : jade_interp) + "</a></p>");
        }).call(this, "isAdmin" in locals_for_with ? locals_for_with.isAdmin : typeof isAdmin !== "undefined" ? isAdmin : undefined, "user" in locals_for_with ? locals_for_with.user : typeof user !== "undefined" ? user : undefined);
        return buf.join("");
    };

    // includes\navbar\loggedout.jade compiled template
    templatizer["includes"]["navbar"]["loggedout"] = function tmpl_includes_navbar_loggedout() {
        return '<div class="navbar-header"><a href="/" class="navbar-brand">OpenABR</a></div><ul class="nav navbar-nav navbar-left"><li><a href="/about">About</a></li><li><a href="/contact">Contact</a></li></ul><ul class="nav navbar-nav navbar-right"><li><a href="/login" class="loginAnchor">Login</a></li></ul>';
    };

    // includes\pager.jade compiled template
    templatizer["includes"]["pager"] = function tmpl_includes_pager() {
        return '<nav id="pager-control"><ul class="pagination"></ul></nav>';
    };

    // navbar.jade compiled template
    templatizer["navbar"] = function tmpl_navbar() {
        return '<nav class="navbar navbar-default navbar-inverse"><div class="container-fluid navbar-content"></div></nav>';
    };

    // pages\401.jade compiled template
    templatizer["pages"]["401"] = function tmpl_pages_401() {
        return '<div class="container"><h2>401<small>&nbsp;You are not authorised! Don\'t try that again or ill report you...</small></h2><p>You are trying to access a feature or resource that is likely for administrators only.</p><p>Don\'t panic! This is not the end! If you really need this feature or resource, why not contact an actual administrator?</p><a href="/contact">Contact the admin!</a></div>';
    };

    // pages\404.jade compiled template
    templatizer["pages"]["404"] = function tmpl_pages_404() {
        return '<div class="container"><h2>404<small>&nbsp;Gah! That was not supposed to happen</small></h2><p>There is nothing currently at this link address! Maybe you mistyped or copied a bad one.</p><p>Don\'t panic and remain calm, use the navbar above to go somewhere safe!</p><p>Oh, and if this continues to happen&nbsp;<a href="/contact">contact the admin!</a></p></div>';
    };

    // pages\about.jade compiled template
    templatizer["pages"]["about"] = function tmpl_pages_about() {
        return '<div class="container"><h2>About OpenABR</h2><img src="/img/abrexample.png" alt="Example of ABR waveform" class="img-rounded"/><p>OpenABR is an cloud-hosted tool for storing and analysing Auditory Brainstem Response (ABR) data. Its purpose is to provide hearing researchers faster collection and analysis of ABRs. Additionalty it is hoped that by collecting various ABRS from other organisations and pooling the data better models and analysis processes can be developed.</p><p>OpenABR was originally created by Samuel Kirkpatrick for the Ryugo Lab based at the Garvin Institute, Sydney Australia, as part of a Master of Engineering degree at University of Technology, Sydney (UTS). It is currently being developed with the goal of becoming an open-source self-sustaining tool for researchers.</p><p>Interested? Please see the&nbsp;<a href="contact">contact page</a>&nbsp;for more infomation.</p></div>';
    };

    // pages\admin\fields\createDataField.jade compiled template
    templatizer["pages"]["admin"]["fields"]["createDataField"] = function tmpl_pages_admin_fields_createDataField() {
        return '<div class="container"><h2>Create New Data Field&nbsp;<small data-hook="collection-name"></small></h2><form data-hook="field-form"><fieldset data-hook="field-container"></fieldset><div class="btn-group"><button data-hook="reset" type="submit" class="btn btn-primary">Submit</button><button data-hook="cancel" type="button" class="btn btn-default">Cancel</button></div></form></div>';
    };

    // pages\admin\fields\editDataField.jade compiled template
    templatizer["pages"]["admin"]["fields"]["editDataField"] = function tmpl_pages_admin_fields_editDataField() {
        return '<div class="container"><h2>Edit Data Field&nbsp;<small data-hook="collection-name"></small></h2><form data-hook="data-field-form"><fieldset data-hook="field-container"></fieldset><div class="btn-group"><button data-hook="reset" type="submit" class="btn btn-primary">Submit</button><button data-hook="cancel" type="button" class="btn btn-default">Cancel</button></div></form><hr/><div class="panel panel-default"><div class="panel-heading"><div class="panel-title">Actions</div></div><div class="panel-body"><div data-hook="delete-confirm"></div></div></div></div>';
    };

    // pages\admin\fields\index.jade compiled template
    templatizer["pages"]["admin"]["fields"]["index"] = function tmpl_pages_admin_fields_index() {
        return '<div><h2>Fields Administration&nbsp;<small>Help</small></h2><ul class="nav nav-pills"><li role="presentation" class="active"><a href="/admin/fields">Help</a></li><li role="presentation"><a href="/admin/fields/subject">Subject</a></li><li role="presentation"><a href="/admin/fields/experiment">Experiment</a></li><li role="presentation"><a href="/admin/fields/abr-group">ABR Group</a></li><li role="presentation"><a href="/admin/fields/abr-set">ABR Set</a></li><li role="presentation"><a href="/admin/fields/abr-reading">ABR Reading</a></li></ul><p>The fillowing section will eventually explain how all of this fields marlarky works, not today bob.</p></div>';
    };

    // pages\admin\fields\list.jade compiled template
    templatizer["pages"]["admin"]["fields"]["list"] = function tmpl_pages_admin_fields_list() {
        return '<div><h2>Fields Administration&nbsp;<small data-hook="collection-name"></small></h2><ul data-hook="fields-nav" class="nav nav-pills"><li role="presentation"><a href="/admin/fields">Help</a></li><li role="presentation" class="subject-li"><a href="/admin/fields/subject">Subject</a></li><li role="presentation" class="experiment-li"><a href="/admin/fields/experiment">Experiment</a></li><li role="presentation" class="abr-group-li"><a href="/admin/fields/abr-group">ABR Group</a></li><li role="presentation" class="abr-set-li"><a href="/admin/fields/abr-set">ABR Set</a></li><li role="presentation" class="abr-reading-li"><a href="/admin/fields/abr-reading">ABR Reading</a></li></ul><hr/><h3>Fixed Fields</h3><table class="table table-hover"><thead><th>Name</th><th>Type</th><th>Database Name</th><th>Required</th><th>Automatic</th><th>Description</th></thead><tbody data-hook="fixed-fields-table"></tbody></table><hr/><h3>User Fields&nbsp;<small><button data-hook="add-user-field" class="btn btn-primary btn-sm">Add new</button></small></h3><table class="table table-hover"><thead><th>Name</th><th>Type</th><th>Database Name</th><th>Required</th><th>Automatic</th><th>Creator</th><th>Description</th></thead><tbody data-hook="fields-table"></tbody></table></div>';
    };

    // pages\admin\users\create.jade compiled template
    templatizer["pages"]["admin"]["users"]["create"] = function tmpl_pages_admin_users_create() {
        return '<div class="container"><h2>Create User</h2><form data-hook="user-form"><fieldset data-hook="field-container"></fieldset><div class="alert alert-info"><strong>Please Note&nbsp;</strong>A password will be automatically generated and displayed post submission.</div><div class="btn-group"><button data-hook="reset" type="submit" class="btn btn-primary">Submit</button><button data-hook="cancel" type="button" class="btn btn-default">Cancel</button></div></form></div>';
    };

    // pages\admin\users\edit.jade compiled template
    templatizer["pages"]["admin"]["users"]["edit"] = function tmpl_pages_admin_users_edit() {
        return '<div class="container"><h2>Edit User</h2><form data-hook="user-form"><fieldset data-hook="field-container"></fieldset><div class="btn-group"><button data-hook="reset" type="submit" class="btn btn-primary">Submit</button><button data-hook="cancel" type="button" class="btn btn-default">Cancel</button></div></form><hr/><div class="panel panel-default"><div class="panel-heading"><div class="panel-title">Actions</div></div><div class="panel-body"><div data-hook="delete-confirm"></div><div data-hook="reset-password-confirm"></div></div></div></div>';
    };

    // pages\admin\users\password.jade compiled template
    templatizer["pages"]["admin"]["users"]["password"] = function tmpl_pages_admin_users_password() {
        return '<div class="container"><div class="row"><div class="panel panel-info"><div class="panel-heading"><div class="panel-title"><span class="glyphicon glyphicon-lock"></span>&nbsp;Generated Password</div></div><div class="panel-body"><p>The following should be copied and provided to the user to login.</p><hr/><div class="row"><div class="col-xs-2"><strong>Name:</strong></div><div data-hook="name" class="col-xs-10"></div></div><div class="row"><div class="col-xs-2"><strong>Email:</strong></div><div data-hook="email" class="col-xs-10"></div></div><div class="row"><div class="col-xs-2"><strong>Password:</strong></div><div data-hook="password" class="col-xs-10"></div></div></div><div class="panel-footer"><strong>Please ensure that the user changes this password as soon as possibile.</strong></div></div></div><div class="row"><a href="/admin/users">Back to users...</a></div></div>';
    };

    // pages\admin\users\users.jade compiled template
    templatizer["pages"]["admin"]["users"]["users"] = function tmpl_pages_admin_users_users() {
        return '<div class="container"><h2>Users</h2><div class="row"><div class="col-sm-9"><input data-hook="filter" class="form-control"/></div><div class="col-sm-3"><button id="newUser" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span>&nbsp;new user</button></div></div><hr/><table class="table table-hover"><thead><th>Name</th><th>Email</th><th>Position</th></thead><tbody data-hook="users-table"></tbody></table><hr/><div data-hook="pagination-control" class="row"></div></div>';
    };

    // pages\contact.jade compiled template
    templatizer["pages"]["contact"] = function tmpl_pages_contact() {
        return '<div class="container"><h2>Contact</h2><p>The system currently is invite only, please send an email to join to chat about this possibility if you are interested.</p><ul><li>To join please email join (at) openabr (dot) com</li><li>To report problems with the service please email admin (at) openabr (dot) com</li></ul></div>';
    };

    // pages\experiments\create.jade compiled template
    templatizer["pages"]["experiments"]["create"] = function tmpl_pages_experiments_create() {
        return '<div class="container"><div class="col-md-offset-2 col-md-8"><h2>Create Experiment</h2><form data-hook="experiment-form"><fieldset data-hook="field-container"></fieldset><div class="btn-group"><button data-hook="reset" type="submit" class="btn btn-primary">Submit</button><button data-hook="cancel" type="button" class="btn btn-default">Cancel</button></div></form><hr/><div class="row"><div class="col-sm-12"><h4>Include Other Fields</h4><div id="fieldArea"></div></div></div></div></div>';
    };

    // pages\experiments\edit.jade compiled template
    templatizer["pages"]["experiments"]["edit"] = function tmpl_pages_experiments_edit() {
        return '<div class="container"><div class="col-md-offset-2 col-md-8"><h2>Edit Experiment</h2><form data-hook="experiment-form"><fieldset data-hook="field-container"></fieldset><div class="btn-group"><button data-hook="reset" type="submit" class="btn btn-primary">Update</button><button data-hook="cancel" type="button" class="btn btn-default">Cancel</button></div></form><hr/><div class="row"><div class="col-sm-12"><h4>Include Other Fields</h4><div id="fieldArea"></div></div></div></div></div>';
    };

    // pages\experiments\index.jade compiled template
    templatizer["pages"]["experiments"]["index"] = function tmpl_pages_experiments_index() {
        return '<div class="container"><h2>Experiments</h2><div class="row"><div class="col-sm-9"><input data-hook="filter" class="form-control"/></div><div class="col-sm-3"><button id="newItem" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span>&nbsp;new experiment</button></div></div><hr/><table class="table table-hover"><thead><th>Name</th><th>Description</th><th>Researcher</th><th># Subjects</th><th># ABRs</th></thead><tbody data-hook="experiments-table"></tbody></table><hr/><div data-hook="pagination-control" class="row"></div></div>';
    };

    // pages\experiments\remove.jade compiled template
    templatizer["pages"]["experiments"]["remove"] = function tmpl_pages_experiments_remove() {
        return '<div class="container"><div class="row"><h2><span data-hook="title"></span>&nbsp;<small data-hook="subtitle"></small></h2></div><div class="row"><h1>Warning!</h1><p>Clicking remove below will&nbsp;<strong><u>remove all related ABR\'s</u></strong></p><p>If you are sure you know what you are doing click remove below to proceed.</p></div><div class="row"><div class="btn-group"><button data-hook="cancel" type="button" class="btn btn-default">Cancel&nbsp;<span class="glyphicon glyphicon-step-backward"></span></button><button data-hook="remove" type="button" class="btn btn-danger">Remove&nbsp;<span class="glyphicon glyphicon-remove"></span></button></div></div></div>';
    };

    // pages\experiments\view.jade compiled template
    templatizer["pages"]["experiments"]["view"] = function tmpl_pages_experiments_view() {
        return '<div class="container"><div class="row"><h2><span data-hook="title"></span>&nbsp;<small data-hook="subtitle">Experiment</small></h2></div><div class="row"><div class="col-lg-8"><div class="row"><div class="panel panel-default"><div data-hook="description" class="panel-body"></div></div></div><div role="tabpanel" class="row"><ul role="tablist" id="graphTabs" class="nav nav-tabs"><li role="presentation" class="active"><a href="#threshold-analysis-tab" role="tab" data-toggle="tab">Threshold Analysis</a></li><li role="presentation"><a href="#latency-analysis-tab" role="tab" data-toggle="tab">Latency Analysis</a></li></ul><div class="tab-content"><div id="threshold-analysis-tab" role="tabpanel" class="tab-pane active"><div data-hook="threshold-analysis-graph"></div></div><div id="latency-analysis-tab" role="tabpanel" class="tab-pane"><div data-hook="latency-analysis-graph"></div></div></div></div><div class="row"><div class="panel panel-default"><div class="panel-heading"><h4 class="panel-title">Experiment Subjects</h4></div><div class="panel-body"><table class="table table-hover"><thead><th>Ref</th><th>Strain</th><th>Species</th><th>DOB</th><th>DOD</th><th>ABRs</th></thead><tbody data-hook="subjects"></tbody></table></div></div></div></div><div class="col-lg-4"><div class="panel panel-default"><div class="panel-heading"><h4 class="panel-title">Actions</h4></div><div class="panel-body"><div class="btn-group btn-group-justified"><div class="btn-group"><button data-hook="edit" class="btn btn-primary">Edit Details</button></div><div class="btn-group"><button data-hook="remove" class="btn btn-warning">Remove</button></div></div></div></div><div class="panel panel-default"><div class="panel-heading"><h4 class="panel-title">Experiment Details</h4></div><div class="panel-body"><div data-hook="details"></div></div></div></div></div></div>';
    };

    // pages\home.jade compiled template
    templatizer["pages"]["home"] = function tmpl_pages_home() {
        return "<div class=\"container\"><h2>Welcome to OpenABR</h2><p>Please contact your administrator for access, or select 'login' to get started!</p></div>";
    };

    // pages\login.jade compiled template
    templatizer["pages"]["login"] = function tmpl_pages_login() {
        return '<div class="container"><form role="form" class="form-signin"><div id="failedLoginAlert" class="alert alert-danger hidden">Incorrect email or password.</div><h2 class="form-signin-heading">Sign in to OpenABR</h2><input id="emailAddress" type="email" placeholder="Email Address" required="required" autofocus="autofocus" class="form-control"/><input id="password" type="password" placeholder="Password" required="required" class="form-control"/><div class="checkbox"><label><input id="rememberMe" type="checkbox" value="remember-me"/>&nbsp;Remember me</label></div><button type="submit" class="btn btn-lg btn-primary btn-block">Login</button></form></div>';
    };

    // pages\profile\change.jade compiled template
    templatizer["pages"]["profile"]["change"] = function tmpl_pages_profile_change() {
        return '<div class="container"><h2>Change Password</h2><p>To change your password please enter your current password then your new desired password.</p><i>If you can not remember your current password please contact your administrator.</i><hr/><form data-hook="user-form"><fieldset data-hook="field-container"></fieldset><div class="btn-group"><button data-hook="reset" type="submit" class="btn btn-primary">Submit</button><button data-hook="cancel" type="button" class="btn btn-default">Cancel</button></div></form></div>';
    };

    // pages\profile\edit.jade compiled template
    templatizer["pages"]["profile"]["edit"] = function tmpl_pages_profile_edit() {
        return '<div class="container"><h2>Edit Profile</h2><form data-hook="user-form"><fieldset data-hook="field-container"></fieldset><div class="btn-group"><button data-hook="reset" type="submit" class="btn btn-primary">Submit</button><button data-hook="cancel" type="button" class="btn btn-default">Cancel</button></div></form></div>';
    };

    // pages\profile\view.jade compiled template
    templatizer["pages"]["profile"]["view"] = function tmpl_pages_profile_view() {
        return '<div class="container"><div class="row"><h1>Profile</h1></div><div class="row"><div class="col-md-3"><strong>Name:</strong></div><div data-hook="name" class="col-md-9"></div><div class="col-md-3"><strong>Email:</strong></div><div data-hook="email" class="col-md-9"></div><div class="col-md-3"><strong>Position:</strong></div><div data-hook="position" class="col-md-9"></div><div class="col-md-3"><strong>Unique Id:</strong></div><div data-hook="id" class="col-md-9"></div></div><div class="row push20"><div class="col-md-3"><strong>Profile:</strong></div><div class="col-md-9"><button id="edit" class="btn btn-default">Edit</button></div></div><div class="row push20"><div class="col-md-3"><strong>Change:</strong></div><div class="col-md-9"><button id="changePassword" class="btn btn-default">Password</button></div></div></div>';
    };

    // pages\query\groups.jade compiled template
    templatizer["pages"]["query"]["groups"] = function tmpl_pages_query_groups() {
        return '<div class="container"><h2>Query<small>&nbsp;ABR Groups</small>&nbsp;&nbsp;<small><a href="/query/sets" class="query-subtitle-link"><span class="glyphicon glyphicon-share-alt"></span>&nbsp;ABR Sets</a></small>&nbsp;&nbsp;<small><a href="/query/readings" class="query-subtitle-link"><span class="glyphicon glyphicon-share-alt"></span>&nbsp;ABR Readings</a></small></h2><div class="row"><div class="col-sm-6"><input id="subjects" class="form-control"/></div><div class="col-sm-6"><input id="experiments" class="form-control"/></div></div><hr/><table class="table table-hover"><thead><th>Date</th><th>Subject</th><th>Experiments</th><th>Tags</th><th>Type</th><th>Ear</th><th>Source</th><th>Uploaded</th><th>Uploader</th></thead><tbody data-hook="groups-table"></tbody></table><hr/><div data-hook="pagination-control" class="row"></div></div>';
    };

    // pages\query\readings.jade compiled template
    templatizer["pages"]["query"]["readings"] = function tmpl_pages_query_readings() {
        return '<div class="container"><h2>Query<small>&nbsp;ABR Readings</small>&nbsp;&nbsp;<small><a href="/query/sets" class="query-subtitle-link"><span class="glyphicon glyphicon-share-alt"></span>&nbsp;ABR Sets</a></small>&nbsp;&nbsp;<small><a href="/query/groups" class="query-subtitle-link"><span class="glyphicon glyphicon-share-alt"></span>&nbsp;ABR Groups</a></small></h2><div class="row"><div class="col-sm-6"><input id="subjects" class="form-control"/></div><div class="col-sm-6"><input id="experiments" class="form-control"/></div></div><hr/><table class="table table-hover"><thead><th>Date</th><th>Subject</th><th>Experiments</th><th>Tags</th><th>Freq (kHz)</th><th>Level (dB)</th><th>Latency?</th><th>Duration (ms)</th><th>Sample Rate</th><th>Samples</th><th>Max (uV)</th><th>Min (uV)</th></thead><tbody data-hook="readings-table"></tbody></table><hr/><div data-hook="pagination-control" class="row"></div></div>';
    };

    // pages\query\sets.jade compiled template
    templatizer["pages"]["query"]["sets"] = function tmpl_pages_query_sets() {
        return '<div class="container"><h2>Query<small>&nbsp;ABR Sets</small>&nbsp;&nbsp;<small><a href="/query/readings" class="query-subtitle-link"><span class="glyphicon glyphicon-share-alt"></span>&nbsp;ABR Readings</a></small>&nbsp;&nbsp;<small><a href="/query/groups" class="query-subtitle-link"><span class="glyphicon glyphicon-share-alt"></span>&nbsp;ABR Groups</a></small></h2><div class="row"><div class="col-sm-6"><input id="subjects" class="form-control"/></div><div class="col-sm-6"><input id="experiments" class="form-control"/></div></div><hr/><table class="table table-hover"><thead><th>Date</th><th>Subject</th><th>Experiments</th><th>Tags</th><th>Type</th><th>Freq (kHz)</th><th>Threshold</th></thead><tbody data-hook="sets-table"></tbody></table><hr/><div data-hook="pagination-control" class="row"></div></div>';
    };

    // pages\status.jade compiled template
    templatizer["pages"]["status"] = function tmpl_pages_status() {
        return '<div class="container"><h2>Welcome to OpenABR</h2><div class="row"><div class="col-md-6"><h4>Your Subjects</h4><table class="table table-hover table-condensed"><thead><th>Reference</th><th>Strain</th><th>Species</th><th>DOB</th><th>DOD</th><th>Researcher</th><th>Experiments</th></thead><tbody data-hook="subject-table"></tbody></table></div><div class="col-md-6"><h4>Your Experiments</h4><table class="table table-hover table-condensed"><thead><th>Name</th><th>Description</th><th>Researcher</th><th>Subjects</th><th>Abr</th></thead><tbody data-hook="experiment-table"></tbody></table></div></div></div>';
    };

    // pages\subjects\create.jade compiled template
    templatizer["pages"]["subjects"]["create"] = function tmpl_pages_subjects_create() {
        return '<div class="container"><div class="col-md-offset-2 col-md-8"><h2>Create Subject</h2><form data-hook="subject-form"><fieldset data-hook="field-container"></fieldset><div class="btn-group"><button data-hook="reset" type="submit" class="btn btn-primary">Submit</button><button data-hook="cancel" type="button" class="btn btn-default">Cancel</button></div></form><hr/><div class="row"><div class="col-sm-12"><h4>Include Other Fields</h4><div id="fieldArea"></div></div></div></div></div>';
    };

    // pages\subjects\edit.jade compiled template
    templatizer["pages"]["subjects"]["edit"] = function tmpl_pages_subjects_edit() {
        return '<div class="container"><div class="col-md-offset-2 col-md-8"><h2>Edit Subject</h2><form data-hook="subject-form"><fieldset data-hook="field-container"></fieldset><div class="btn-group"><button data-hook="reset" type="submit" class="btn btn-primary">Update</button><button data-hook="cancel" type="button" class="btn btn-default">Cancel</button></div></form><hr/><div class="row"><div class="col-sm-12"><h4>Include Other Fields</h4><div id="fieldArea"></div></div></div></div></div>';
    };

    // pages\subjects\index.jade compiled template
    templatizer["pages"]["subjects"]["index"] = function tmpl_pages_subjects_index() {
        return '<div class="container"><h2>Subjects</h2><div class="row"><div class="col-sm-9"><input data-hook="filter" class="form-control"/></div><div class="col-sm-3"><button id="newSubject" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span>&nbsp;new subject</button></div></div><hr/><table class="table table-hover"><thead><th>Ref</th><th>Strain</th><th>Species</th><th>DOB</th><th>DOD</th><th>Researcher</th><th># Experiments</th></thead><tbody data-hook="subjects-table"></tbody></table><hr/><div data-hook="pagination-control" class="row"></div></div>';
    };

    // pages\subjects\remove.jade compiled template
    templatizer["pages"]["subjects"]["remove"] = function tmpl_pages_subjects_remove() {
        return '<div class="container"><div class="row"><h2><span data-hook="title"></span>&nbsp;<small data-hook="subtitle"></small></h2></div><div class="row"><h1>Warning!</h1><p>Clicking remove below will&nbsp;<strong><u>remove all related ABR\'s</u></strong></p><p>If you are sure you know what you are doing click remove below to proceed.</p></div><div class="row"><div class="btn-group"><button data-hook="cancel" type="button" class="btn btn-default">Cancel&nbsp;<span class="glyphicon glyphicon-step-backward"></span></button><button data-hook="remove" type="button" class="btn btn-danger">Remove&nbsp;<span class="glyphicon glyphicon-remove"></span></button></div></div></div>';
    };

    // pages\subjects\view.jade compiled template
    templatizer["pages"]["subjects"]["view"] = function tmpl_pages_subjects_view() {
        return '<div class="container"><div class="row"><h2><span data-hook="title"></span>&nbsp;<small data-hook="subtitle"></small></h2></div><div class="row"><div class="col-lg-8"><div role="tabpanel" class="row"><ul role="tablist" id="graphTabs" class="nav nav-tabs"><li role="presentation" class="active"><a href="#threshold-analysis-tab" role="tab" data-toggle="tab">Threshold Analysis</a></li><li role="presentation"><a href="#latency-analysis-tab" role="tab" data-toggle="tab">Latency Analysis</a></li></ul><div class="tab-content"><div id="threshold-analysis-tab" role="tabpanel" class="tab-pane active"><div data-hook="threshold-analysis-graph"></div></div><div id="latency-analysis-tab" role="tabpanel" class="tab-pane"><div data-hook="latency-analysis-graph"></div></div></div></div><div data-hook="timeline" class="row"></div><div data-hook="group-show" class="row"></div></div><div class="col-lg-4"><div class="panel panel-default"><div class="panel-heading"><h4 class="panel-title">Actions</h4></div><div class="panel-body"><div class="btn-group btn-group-justified"><div class="btn-group"><button data-hook="edit" class="btn btn-primary">Edit Details</button></div><div class="btn-group"><button data-hook="remove" class="btn btn-warning">Remove</button></div></div></div></div><div class="panel panel-default"><div class="panel-heading"><h4 class="panel-title">Subject Details</h4></div><div class="panel-body"><div data-hook="details"></div></div></div><div data-hook="experiments"></div></div></div></div>';
    };

    // pages\upload\latencyAnalysis.jade compiled template
    templatizer["pages"]["upload"]["latencyAnalysis"] = function tmpl_pages_upload_latencyAnalysis() {
        return '<div class="container"><h2>Upload ABR(s)&nbsp;<small>STEP 3: Latency Analysis</small></h2><div class="row"><ul data-hook="group-select-list" class="nav nav-pills"></ul><hr/></div><div data-hook="analysis-area" class="row"></div><div class="row"><div class="panel panel-default"><div class="panel-footer"><button data-hook="cancel" class="btn btn-default">Cancel</button>&nbsp;&nbsp;<button data-hook="next" class="btn btn-primary">Next Step&nbsp;<span class="glyphicon glyphicon-step-forward"></span></button></div></div></div><div tabindex="-1" role="dialog" aria-hidden="true" id="leaveModal" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><h4 class="modal-title">Are You Sure?</h4></div><div class="modal-body"><p>Any and all work done on importing this ABR will be lost. You will have to start the process from the beginning if you leave now.</p></div><div class="modal-footer"><button data-dismiss="modal" class="btn btn-default">No, take me back.</button><button id="modalQuit" class="btn btn-primary">Yes i\'m sure.</button></div></div></div></div><div tabindex="-1" role="dialog" aria-hidden="true" id="notCompletedAnalysisModal" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><h4 class="modal-title">You have not completed this step.</h4></div><div class="modal-body"><p>If you skip this step you may have to come back and do it later! Are you sure you want to continue?</p></div><div class="modal-footer"><button data-dismiss="modal" class="btn btn-default">No, take me back.</button><button id="modelNext" class="btn btn-primary">Yes i\'m sure.</button></div></div></div></div></div>';
    };

    // pages\upload\reviewAndCommit.jade compiled template
    templatizer["pages"]["upload"]["reviewAndCommit"] = function tmpl_pages_upload_reviewAndCommit() {
        return '<div class="container"><h2>Upload ABR(s)&nbsp;<small>STEP 4: Review and Commit</small></h2><div class="row"><div class="panel panel-default"><div class="panel-heading"><h4 class="panel-title">Review ABRs For Upload</h4></div><div data-hook="review-area" class="panel-body"><p>To be implemented....</p></div><div class="panel-footer"><button data-hook="cancel" class="btn btn-default">Cancel</button>&nbsp;&nbsp;<button data-hook="next" class="btn btn-primary">Commit to Database<span class="glyphicon glyphicon-step-forward"></span></button></div></div></div><div tabindex="-1" role="dialog" aria-hidden="true" id="leaveModal" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><h4 class="modal-title">Are You Sure?</h4></div><div class="modal-body"><p>Any and all work done on importing this ABR will be lost. You will have to start the process from the beginning if you leave now.</p></div><div class="modal-footer"><button data-dismiss="modal" class="btn btn-default">No, take me back.</button><button id="modalQuit" class="btn btn-primary">Yes i\'m sure.</button></div></div></div></div></div>';
    };

    // pages\upload\selectData.jade compiled template
    templatizer["pages"]["upload"]["selectData"] = function tmpl_pages_upload_selectData() {
        return '<div class="container"><h2>Upload ABR(s)&nbsp;<small>STEP 1: Select Raw Data</small></h2><div class="row"><div class="panel panel-default"><div class="panel-body"><input type="file" data-hook="upload-file" name="file"/></div></div></div><div class="row"><div data-hook="parse-area"></div></div></div>';
    };

    // pages\upload\thresholdAnalysis.jade compiled template
    templatizer["pages"]["upload"]["thresholdAnalysis"] = function tmpl_pages_upload_thresholdAnalysis() {
        return '<div class="container"><h2>Upload ABR(s)&nbsp;<small>STEP 2: Threshold Analysis</small></h2><div class="row"><ul data-hook="group-select-list" class="nav nav-pills"></ul><hr/></div><div class="row"><div class="panel panel-default"><div class="panel-heading"><h4 class="panel-title">Group Threshold Analysis</h4></div><div data-hook="analysis-area" class="panel-body"></div><div class="panel-footer"><button data-hook="cancel" class="btn btn-default">Cancel</button>&nbsp;&nbsp;<button data-hook="next" class="btn btn-primary">Next Step&nbsp;<span class="glyphicon glyphicon-step-forward"></span></button>&nbsp;&nbsp;<button data-hook="autonext" class="btn btn-primary"><strong>Use Automatic Thresholds&nbsp;</strong><span class="glyphicon glyphicon-fast-forward"></span></button></div></div></div><div tabindex="-1" role="dialog" aria-hidden="true" id="leaveModal" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><h4 class="modal-title">Are You Sure?</h4></div><div class="modal-body"><p>Any and all work done on importing this ABR will be lost. You will have to start the process from the beginning if you leave now.</p></div><div class="modal-footer"><button data-dismiss="modal" class="btn btn-default">No, take me back.</button><button id="modalQuit" class="btn btn-primary">Yes i\'m sure.</button></div></div></div></div><div tabindex="-1" role="dialog" aria-hidden="true" id="notCompletedAnalysisModal" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><h4 class="modal-title">You have not completed this step.</h4></div><div class="modal-body"><p>If you skip this step you may have to come back and do it later! Are you sure you want to continue?</p></div><div class="modal-footer"><button data-dismiss="modal" class="btn btn-default">No, take me back.</button><button id="modelNext" class="btn btn-primary">Yes i\'m sure.</button></div></div></div></div></div>';
    };

    // views\abrGroups\groupQueryRow.jade compiled template
    templatizer["views"]["abrGroups"]["groupQueryRow"] = function tmpl_views_abrGroups_groupQueryRow() {
        return '<tr data-hook="group-row"><td data-hook="date"></td><td data-hook="subject"></td><td data-hook="experiments"></td><td data-hook="tags"></td><td data-hook="type"></td><td data-hook="ear"></td><td data-hook="source"></td><td data-hook="created"></td><td data-hook="creator"></td></tr>';
    };

    // views\abrGroups\show.jade compiled template
    templatizer["views"]["abrGroups"]["show"] = function tmpl_views_abrGroups_show() {
        return '<div><hr/><h4><span>Selected Group:</span>&nbsp;<strong data-hook="title"></strong>&nbsp;<small><span data-hook="subtitle"></span></small></h4><div role="tabpanel"><ul role="tablist" id="groupTabs" class="nav nav-tabs"><li role="presentation" class="active"><a href="#threshold" role="tab" data-toggle="tab">Threshold Analysis</a></li><li role="presentation"><a href="#latency" role="tab" data-toggle="tab">Latency Analysis</a></li><li role="presentation"><a href="#sets" role="tab" data-toggle="tab">Sets\n&nbsp;<div data-hook="sets-count" class="badge">...</div></a></li><li role="presentation"><a href="#readings" role="tab" data-toggle="tab">Readings\n&nbsp;<div data-hook="readings-count" class="badge">...</div></a></li></ul><div class="tab-content"><div id="threshold" role="tabpanel" class="tab-pane active"><div class="panel panel-default panel-tab"><div class="panel-body"><div data-hook="threshold-analysis-graph">loading threshold analysis...</div></div></div></div><div id="latency" role="tabpanel" class="tab-pane"><div class="panel panel-default panel-tab"><div class="panel-body"><div data-hook="latency-analysis-graph">loading latency analysis...</div></div></div></div><div id="sets" role="tabpanel" class="tab-pane"><div class="panel panel-default panel-tab"><div class="panel-body"><div data-hook="sets-list">Coming Soon!</div></div></div></div><div id="readings" role="tabpanel" class="tab-pane"><div class="panel panel-default panel-tab"><div class="panel-body"><div data-hook="readings-list">loading reading list...</div></div></div></div></div></div></div>';
    };

    // views\abrReadings\list.jade compiled template
    templatizer["views"]["abrReadings"]["list"] = function tmpl_views_abrReadings_list() {
        return '<div><table class="table table-hover table-condensed"><thead><th>Freq (kHz)</th><th>Level (dB)</th><th>Pk1</th><th>Pk2</th><th>Pk3</th><th>Pk4</th><th>Pk5</th></thead><tbody data-hook="reading-list"></tbody></table></div>';
    };

    // views\abrReadings\readingQueryRow.jade compiled template
    templatizer["views"]["abrReadings"]["readingQueryRow"] = function tmpl_views_abrReadings_readingQueryRow() {
        return '<tr data-hook="reading-row"><td data-hook="date"></td><td data-hook="subject"></td><td data-hook="experiments"></td><td data-hook="tags"></td><td data-hook="freq"></td><td data-hook="level"></td><td><span data-hook="latency" class="glyphicon glyphicon-ok"></span></td><td data-hook="duration"></td><td data-hook="sampleRate"></td><td data-hook="numberSamples"></td><td data-hook="valueMax"></td><td data-hook="valueMin"></td></tr>';
    };

    // views\abrReadings\readingRow.jade compiled template
    templatizer["views"]["abrReadings"]["readingRow"] = function tmpl_views_abrReadings_readingRow() {
        return '<tr data-hook="reading-row"><td data-hook="freq"></td><td data-hook="level"></td><td data-hook="latency1"></td><td data-hook="latency2"></td><td data-hook="latency3"></td><td data-hook="latency4"></td><td data-hook="latency5"></td></tr>';
    };

    // views\abrSets\setQueryRow.jade compiled template
    templatizer["views"]["abrSets"]["setQueryRow"] = function tmpl_views_abrSets_setQueryRow() {
        return '<tr data-hook="set-row"><td data-hook="date"></td><td data-hook="subject"></td><td data-hook="experiments"></td><td data-hook="tags"></td><td data-hook="type"></td><td data-hook="freq"></td><td data-hook="threshold"></td></tr>';
    };

    // views\analysis\groupLatency.jade compiled template
    templatizer["views"]["analysis"]["groupLatency"] = function tmpl_views_analysis_groupLatency() {
        return '<div class="row"><div class="col-lg-12"><div hidden="hidden" id="infoAlert" class="alert alert-info">Info Alert</div><div hidden="hidden" id="successAlert" class="alert alert-success">Success Alert</div></div><div class="col-lg-12"><div class="row"><div data-hook="analysis-area" class="col-md-9"></div><div class="col-md-3"><div class="panel panel-default"><div class="panel-heading"><h4 class="panel-title">Readings</h4></div><div class="panel-body"><ul style="display: none;" class="list-group"></ul><ul data-hook="reading-select-list" class="list-group"></ul></div></div><div class="panel panel-default"><div class="panel-heading"><h4 class="panel-title">Sets</h4></div><div class="panel-body"><ul data-hook="set-select-list" class="list-group"></ul></div></div></div></div></div></div>';
    };

    // views\analysis\groupThreshold.jade compiled template
    templatizer["views"]["analysis"]["groupThreshold"] = function tmpl_views_analysis_groupThreshold() {
        return '<div class="row"><div class="col-md-12"><div class="row"><div class="col-md-9"><h4 data-hook="name"></h4></div><div class="col-md-3"><button data-hook="auto-threshold-group" class="btn btn-primary btn-block">Auto Threshold</button></div><div class="col-md-12"><hr/></div></div><div class="row"><div class="col-md-9"><div data-hook="analysis-area"></div></div><div class="col-md-3"><ul data-hook="set-select-list" class="list-group"></ul></div></div></div></div>';
    };

    // views\analysis\readingLatency.jade compiled template
    templatizer["views"]["analysis"]["readingLatency"] = function tmpl_views_analysis_readingLatency(locals) {
        var buf = [];
        var jade_mixins = {};
        var jade_interp;
        var locals_for_with = locals || {};
        (function(model) {
            buf.push('<div><div class="panel panel-default"><div class="panel-heading"><h4 class="panel-title">ABR Latency Analyser</h4></div><div class="panel-body"><div id="abrGraph"></div></div><div class="panel-footer"><div class="btn-toolbar"><div class="btn-group"><button type="button" id="mark-peaks" class="btn btn-primary"><span class="glyphicon glyphicon-screenshot"></span>&nbsp; Mark Peaks</button><button type="button" data="1" class="btn btn-default mark-peak">I</button><button type="button" data="2" class="btn btn-default mark-peak">II</button><button type="button" data="3" class="btn btn-default mark-peak">III</button><button type="button" data="4" class="btn btn-default mark-peak">IV</button><button type="button" data="5" class="btn btn-default mark-peak">V</button></div><button type="button" data-containerId="abrGraph"' + jade.attr("data-filename", model.imageFilename, true, false) + ' class="btn btn-info btn-svg-as-png">Save as PNG</button><button type="button" id="mark-complete" class="btn btn-default pull-right"><span class="glyphicon glyphicon-ok"></span>&nbsp; Mark Complete</button><button type="button" id="clear-complete" class="btn btn-warning pull-right"><span class="glyphicon glyphicon-remove"></span>&nbsp; Clear Complete</button><button type="button" id="complete-and-next" class="btn btn-primary"><span class="glyphicon glyphicon-repeat"></span>&nbsp; Complete & Next</button></div></div></div></div>');
        }).call(this, "model" in locals_for_with ? locals_for_with.model : typeof model !== "undefined" ? model : undefined);
        return buf.join("");
    };

    // views\analysis\setThreshold.jade compiled template
    templatizer["views"]["analysis"]["setThreshold"] = function tmpl_views_analysis_setThreshold() {
        return '<div class="well"><div class="row"><div class="col-sm-4"><h4 data-hook="name"></h4></div><div class="col-sm-3"><div class="btn-group"><button data-hook="clear" class="btn btn-warning">Clear</button><button data-hook="no-response" class="btn btn-info">No Response</button></div></div><div class="col-sm-5"><button data-hook="use-automatic" class="btn btn-info btn-block"></button></div></div><div class="row"><hr style="border-color: black;"/></div><div class="row"><div data-hook="levels" class="col-sm-3 list-group"></div><div id="abrSetGraph" class="col-sm-9"></div></div></div>';
    };

    // views\experiments\experimentRow.jade compiled template
    templatizer["views"]["experiments"]["experimentRow"] = function tmpl_views_experiments_experimentRow() {
        return '<tr data-hook="experiment-row"><td data-hook="name"></td><td data-hook="description"></td><td data-hook="researcher"></td><td data-hook="subjects"><img src="/img/spinner.gif"/></td><td data-hook="abrs"><img src="/img/spinner.gif"/></td></tr>';
    };

    // views\experiments\selectAbrExperiments.jade compiled template
    templatizer["views"]["experiments"]["selectAbrExperiments"] = function tmpl_views_experiments_selectAbrExperiments(locals) {
        var buf = [];
        var jade_mixins = {};
        var jade_interp;
        var locals_for_with = locals || {};
        (function(experiments) {
            buf.push('<div class="panel panel-default"><div class="panel-heading"><h5 class="panel-title">Experiments</h5></div><div class="panel-body"><input' + jade.attr("value", experiments.join(","), true, false) + ' class="form-control"/></div></div>');
        }).call(this, "experiments" in locals_for_with ? locals_for_with.experiments : typeof experiments !== "undefined" ? experiments : undefined);
        return buf.join("");
    };

    // views\graphs\latency\config.jade compiled template
    templatizer["views"]["graphs"]["latency"]["config"] = function tmpl_views_graphs_latency_config() {
        return "<p>config view</p>";
    };

    // views\graphs\latency\data.jade compiled template
    templatizer["views"]["graphs"]["latency"]["data"] = function tmpl_views_graphs_latency_data() {
        return "<p>data view</p>";
    };

    // views\graphs\latency\graph.jade compiled template
    templatizer["views"]["graphs"]["latency"]["graph"] = function tmpl_views_graphs_latency_graph() {
        return "<p>graph view</p>";
    };

    // views\graphs\latency\main.jade compiled template
    templatizer["views"]["graphs"]["latency"]["main"] = function tmpl_views_graphs_latency_main() {
        return '<div><ul class="nav nav-pills"><li role="presentation" class="active"><a id="showGraphPill" style="cursor: pointer;">Graph</a></li><li role="presentation"><a id="showConfigPill" style="cursor: pointer;">Config</a></li><li role="presentation"><a id="showDataPill" style="cursor: pointer;">Data</a></li></ul><div data-hook="switch-area"></div></div>';
    };

    // views\graphs\threshold\config.jade compiled template
    templatizer["views"]["graphs"]["threshold"]["config"] = function tmpl_views_graphs_threshold_config() {
        return '<div data-hook="config-area"><h4>Threshold Graph Configuration</h4><div class="form-group"><label>Mode</label><p data-hook="mode" class="form-control-static"></p></div><div id="groupBySection" class="form-group"><label>Group By</label><select data-hook="group-by" class="form-control"><option value="date-simple">Simple ABR Date</option><option value="age-monthly">Age Coalesced to Monthly (4,8,12 etc)</option></select></div></div>';
    };

    // views\graphs\threshold\data.jade compiled template
    templatizer["views"]["graphs"]["threshold"]["data"] = function tmpl_views_graphs_threshold_data() {
        return '<div><h4>Threshold Graph Raw Data</h4><table class="table table-condensed"><thead data-hook="table-headers"></thead><tbody data-hook="raw-data-table"></tbody></table><div class="btn-group"><button data-hook="export-csv" class="btn btn-default">Export To CSV File</button><button data-hook="export-json" class="btn btn-default">Export To JSON File</button></div></div>';
    };

    // views\graphs\threshold\graph.jade compiled template
    templatizer["views"]["graphs"]["threshold"]["graph"] = function tmpl_views_graphs_threshold_graph() {
        return '<div><h4>Threshold Analysis Graph</h4><div data-hook="threshold-analysis-graph">loading...</div></div>';
    };

    // views\graphs\threshold\main.jade compiled template
    templatizer["views"]["graphs"]["threshold"]["main"] = function tmpl_views_graphs_threshold_main() {
        return '<div><ul class="nav nav-pills"><li role="presentation" class="active"><a id="showGraphPill" style="cursor: pointer;">Graph</a></li><li role="presentation"><a id="showConfigPill" style="cursor: pointer;">Config</a></li><li role="presentation"><a id="showDataPill" style="cursor: pointer;">Data</a></li></ul><div data-hook="switch-area"></div></div>';
    };

    // views\subjects\createSubject.jade compiled template
    templatizer["views"]["subjects"]["createSubject"] = function tmpl_views_subjects_createSubject() {
        return '<div class="panel panel-default"><div class="panel-heading"><h5 class="panel-title">Create Subject</h5></div><div class="panel-body"><form data-hook="subject-form"><fieldset data-hook="field-container"></fieldset><div class="btn-group"><button data-hook="reset" type="submit" class="btn btn-primary">Submit</button><button data-hook="cancel" type="button" class="btn btn-default">Cancel</button></div></form></div></div>';
    };

    // views\subjects\selectSubject.jade compiled template
    templatizer["views"]["subjects"]["selectSubject"] = function tmpl_views_subjects_selectSubject(locals) {
        var buf = [];
        var jade_mixins = {};
        var jade_interp;
        var locals_for_with = locals || {};
        (function(model, val) {
            buf.push('<div class="panel panel-default"><div class="panel-heading"><h5 class="panel-title">Subject</h5></div><div class="panel-body"><div class="row"><div class="col-xs-9">');
            val = "";
            if (model != null) val = model.id;
            buf.push("<input" + jade.attr("value", val, true, false) + ' class="form-control"/></div><div class="col-xs-3"><button data-hook="create-subject" class="btn btn-primary btn-block">Create</button></div></div></div></div>');
        }).call(this, "model" in locals_for_with ? locals_for_with.model : typeof model !== "undefined" ? model : undefined, "val" in locals_for_with ? locals_for_with.val : typeof val !== "undefined" ? val : undefined);
        return buf.join("");
    };

    // views\subjects\selectSubjectExperiments.jade compiled template
    templatizer["views"]["subjects"]["selectSubjectExperiments"] = function tmpl_views_subjects_selectSubjectExperiments(locals) {
        var buf = [];
        var jade_mixins = {};
        var jade_interp;
        var locals_for_with = locals || {};
        (function(model) {
            buf.push('<div class="panel panel-default"><div class="panel-heading"><h5 class="panel-title">Experiments</h5></div><div class="panel-body"><input' + jade.attr("value", model.experiments.join(","), true, false) + ' class="form-control"/></div></div>');
        }).call(this, "model" in locals_for_with ? locals_for_with.model : typeof model !== "undefined" ? model : undefined);
        return buf.join("");
    };

    // views\subjects\shortSubjectRow.jade compiled template
    templatizer["views"]["subjects"]["shortSubjectRow"] = function tmpl_views_subjects_shortSubjectRow() {
        return '<tr data-hook="subject-row"><td data-hook="reference"></td><td data-hook="strain"></td><td data-hook="species"></td><td data-hook="dob"></td><td data-hook="dod"></td><td data-hook="abr-details"></td></tr>';
    };

    // views\subjects\subjectRow.jade compiled template
    templatizer["views"]["subjects"]["subjectRow"] = function tmpl_views_subjects_subjectRow() {
        return '<tr data-hook="subject-row"><td data-hook="reference"></td><td data-hook="strain"></td><td data-hook="species"></td><td data-hook="dob"></td><td data-hook="dod"></td><td data-hook="researcher"></td><td data-hook="experiments"></td></tr>';
    };

    // views\subjects\subjectSelector.jade compiled template
    templatizer["views"]["subjects"]["subjectSelector"] = function tmpl_views_subjects_subjectSelector() {
        return '<div data-hook="area"></div>';
    };

    // views\upload\groupPillView.jade compiled template
    templatizer["views"]["upload"]["groupPillView"] = function tmpl_views_upload_groupPillView() {
        return '<li data-hook="group-list-item" style="cursor: pointer;"><a><span data-hook="name"></span>&nbsp;&nbsp;<span data-hook="group-ready" class="glyphicon glyphicon-ok"></span></a></li>';
    };

    // views\upload\groupView.jade compiled template
    templatizer["views"]["upload"]["groupView"] = function tmpl_views_upload_groupView() {
        return '<div class="row"><div class="col-md-12"><h3 style="margin-top:0px;">Group&nbsp;<span data-hook="group-number"></span>&nbsp;<small data-hook="sub-name"></small></h3><div data-hook="sets-area"></div></div></div>';
    };

    // views\upload\readingListView.jade compiled template
    templatizer["views"]["upload"]["readingListView"] = function tmpl_views_upload_readingListView() {
        return '<a data-hook="list-group-item" style="cursor: pointer; text-align: center;" class="list-group-item"><span data-hook="item-ready" class="badge"><span class="glyphicon glyphicon-ok"></span></span><span data-hook="name"></span></a>';
    };

    // views\upload\setListView.jade compiled template
    templatizer["views"]["upload"]["setListView"] = function tmpl_views_upload_setListView() {
        return '<a data-hook="list-group-item" style="cursor: pointer; text-align: center;" class="list-group-item"><span data-hook="set-ready" class="badge"><span class="glyphicon glyphicon-ok"></span></span><span data-hook="name"></span></a>';
    };

    // views\upload\setView.jade compiled template
    templatizer["views"]["upload"]["setView"] = function tmpl_views_upload_setView() {
        return '<div class="col-sm-6 col-md-4"><div data-hook="set-click-area" class="thumbnail"><div data-hook="mini-set-graph"></div><div class="caption"><h4 data-hook="name"></h4><p><span data-hook="reading-count"></span>&nbsp;readings</p><p><div id="is-selected" class="set-selector"><span class="glyphicon glyphicon-ok"></span>&nbsp;Selected</div><div id="not-selected" class="set-selector"><span class="glyphicon glyphicon-remove"></span>&nbsp;Not Selected</div></p></div></div></div>';
    };

    // views\upload\sigGen.jade compiled template
    templatizer["views"]["upload"]["sigGen"] = function tmpl_views_upload_sigGen() {
        return '<div class="panel panel-default"><div class="panel-heading"><h4 class="panel-title">SigGen File</h4></div><div class="panel-body form-horizontal"><div role="alert" id="abr-date-alert" class="alert alert-danger"><strong>Missing Date!&nbsp;</strong>You must select the date that these ABR recordings occured upon.</div><div class="col-sm-3 col-md-6 form-group"><label class="col-xs-5 control-label">Ear</label><div class="col-xs-7"><select data-hook="ear" class="form-control"><option value="-">-</option><option value="Left">Left</option><option value="Right">Right</option></select></div></div><div class="col-sm-3 col-md-6 form-group"><label class="col-xs-5 control-label">ABR Date</label><div class="col-xs-7"><input type="date" data-hook="abr-date" class="form-control"/></div></div><div class="col-sm-3 col-md-6 form-group"><label class="col-xs-5 control-label">Upload Date</label><div class="col-xs-7"><p data-hook="upload-date" class="form-control-static">loading...</p></div></div><div class="col-sm-3 col-md-6 form-group"><label class="col-xs-5 control-label">Uploader</label><div class="col-xs-7"><p data-hook="upload-user" class="form-control-static">loading...</p></div></div></div><div style="margin-bottom: 0px; padding-bottom: 0px;" class="panel-body"><div role="alert" id="subject-alert" class="alert alert-danger"><strong>Missing Subject!&nbsp;</strong>You must select or create the subject that these ABR belong to.</div><div class="row"><div class="col-lg-6 col-md-12"><div data-hook="subject-select"></div></div><div class="col-lg-6 col-md-12"><div data-hook="experiments-select"></div></div></div><div role="alert" style="display: none;" id="sets-alert" class="alert alert-danger"><strong>No Sets Selected!&nbsp;</strong>You must select at least one set, in one group to upload to the system.</div></div><div data-hook="groups-display" style="margin-top: 0px; padding-top: 0px;" class="panel-body"></div><div class="panel-footer"><button data-hook="cancel" class="btn btn-default">Cancel</button>&nbsp;&nbsp;<button data-hook="next" class="btn btn-primary">Next Step&nbsp;<span class="glyphicon glyphicon-step-forward"></span></button></div><div tabindex="-1" role="dialog" aria-hidden="true" id="leaveModal" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><h4 class="modal-title">Are You Sure?</h4></div><div class="modal-body"><p>Any and all work done on importing this ABR will be lost. You will have to start the process from the beginning if you leave now.</p></div><div class="modal-footer"><button data-dismiss="modal" class="btn btn-default">No, take me back.</button><button id="modalQuit" class="btn btn-primary">Yes i\'m sure.</button></div></div></div></div></div>';
    };

    // views\upload\unkownFile.jade compiled template
    templatizer["views"]["upload"]["unkownFile"] = function tmpl_views_upload_unkownFile() {
        return '<div class="panel panel-default"><div class="panel-heading"><h4 class="panel-title">Unknown Format</h4></div><div class="panel-body"><p>The signature of the file you have selected is unknown. It may not be supported.</p><textarea cols="55" data-hook="lines-dump"></textarea></div></div>';
    };

    return templatizer;
}));