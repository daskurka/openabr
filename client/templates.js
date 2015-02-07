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
    templatizer["pages"]["subjects"] = {};
    templatizer["pages"]["upload"] = {};
    templatizer["views"]["experiments"] = {};
    templatizer["views"]["subjects"] = {};
    templatizer["views"]["upload"] = {};
    templatizer["pages"]["admin"]["fields"] = {};
    templatizer["pages"]["admin"]["users"] = {};

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

    // includes\items\experiment.jade compiled template
    templatizer["includes"]["items"]["experiment"] = function tmpl_includes_items_experiment() {
        return '<tr data-hook="experiment-row"><td data-hook="name"></td><td data-hook="description"></td><td data-hook="researcher"></td><td data-hook="subjects"><img src="/img/spinner.gif"/></td><td data-hook="abrs"><img src="/img/spinner.gif"/></td></tr>';
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
            buf.push('<div class="navbar-header"><a href="/" class="navbar-brand">OpenABR</a></div><ul class="nav navbar-nav"><li><a href="/process">Upload ABR</a></li><li><a href="/query">Query ABRs</a></li><li><a href="/experiments">Experiments</a></li><li><a href="/subjects">Subjects</a></li></ul><ul class="nav navbar-nav navbar-right">');
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

    // pages\home.jade compiled template
    templatizer["pages"]["home"] = function tmpl_pages_home() {
        return '<div class="container"><h2>Welcome to OpenABR</h2><p>This site is still in development, any news will be posted here. If you are interested in becoming an early adopter please see the&nbsp;<a href="contact">contact page</a>&nbsp;for more infomation.</p><a href="about">About</a><a href="contact">Contact</a><a href="login">Login</a></div>';
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

    // pages\status.jade compiled template
    templatizer["pages"]["status"] = function tmpl_pages_status() {
        return '<div class="container"><h2>Welcome to OpenABR</h2><p>You are logged in!</p></div>';
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

    // pages\subjects\view.jade compiled template
    templatizer["pages"]["subjects"]["view"] = function tmpl_pages_subjects_view() {
        return '<div class="container"><div class="row"><h2><span data-hook="title"></span>&nbsp;<small data-hook="subtitle"></small></h2></div><div class="row"><div class="col-lg-8"><div class="row"><p>Graph here</p></div><div class="row"><div data-hook="experiments"></div></div><div class="row"><p>history here</p></div></div><div class="col-lg-4"><h4>Subject Details&nbsp;<button data-hook="edit" class="btn btn-primary btn-sm">edit subject</button></h4><div data-hook="details"></div></div></div></div>';
    };

    // pages\upload\selectData.jade compiled template
    templatizer["pages"]["upload"]["selectData"] = function tmpl_pages_upload_selectData() {
        return '<div class="container"><h2>Upload ABR(s)&nbsp;<small>STEP 1: Select Raw Data</small></h2><div class="row"><div class="panel panel-default"><div class="panel-body"><input type="file" data-hook="upload-file" name="file"/></div></div></div><div class="row"><div data-hook="parse-area"></div></div></div>';
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

    // views\subjects\subjectRow.jade compiled template
    templatizer["views"]["subjects"]["subjectRow"] = function tmpl_views_subjects_subjectRow() {
        return '<tr data-hook="subject-row"><td data-hook="reference"></td><td data-hook="strain"></td><td data-hook="species"></td><td data-hook="dob"></td><td data-hook="dod"></td><td data-hook="researcher"></td><td data-hook="experiments"></td></tr>';
    };

    // views\subjects\subjectSelector.jade compiled template
    templatizer["views"]["subjects"]["subjectSelector"] = function tmpl_views_subjects_subjectSelector() {
        return '<div data-hook="area"></div>';
    };

    // views\upload\groupView.jade compiled template
    templatizer["views"]["upload"]["groupView"] = function tmpl_views_upload_groupView() {
        return '<div class="row"><div class="col-md-12"><h3 style="margin-top:0px;">Group&nbsp;<span data-hook="group-number"></span>&nbsp;<small data-hook="sub-name"></small></h3><div data-hook="sets-area"></div></div></div>';
    };

    // views\upload\setView.jade compiled template
    templatizer["views"]["upload"]["setView"] = function tmpl_views_upload_setView() {
        return '<div class="col-sm-6 col-md-4"><div data-hook="set-click-area" class="thumbnail"><div data-hook="mini-set-graph"></div><div class="caption"><h4 data-hook="name"></h4><p><span data-hook="reading-count"></span>&nbsp;readings</p><p><div id="is-selected" class="set-selector"><span class="glyphicon glyphicon-ok"></span>&nbsp;Selected</div><div id="not-selected" class="set-selector"><span class="glyphicon glyphicon-remove"></span>&nbsp;Not Selected</div></p></div></div></div>';
    };

    // views\upload\sigGen.jade compiled template
    templatizer["views"]["upload"]["sigGen"] = function tmpl_views_upload_sigGen() {
        return '<div class="panel panel-default"><div class="panel-heading"><h4 class="panel-title">SigGen File</h4></div><div class="panel-body form-horizontal"><div role="alert" id="abr-date-alert" class="alert alert-danger"><strong>Missing Date!&nbsp;</strong>You must select the date that these ABR recordings occured upon.</div><div class="col-sm-3 col-md-6 form-group"><label class="col-xs-5 control-label">Ear</label><div class="col-xs-7"><select data-hook="ear" class="form-control"><option value="-">-</option><option value="Left">Left</option><option value="Right">Right</option></select></div></div><div class="col-sm-3 col-md-6 form-group"><label class="col-xs-5 control-label">ABR Date</label><div class="col-xs-7"><input type="date" data-hook="abr-date" class="form-control"/></div></div><div class="col-sm-3 col-md-6 form-group"><label class="col-xs-5 control-label">Upload Date</label><div class="col-xs-7"><p data-hook="upload-date" class="form-control-static">loading...</p></div></div><div class="col-sm-3 col-md-6 form-group"><label class="col-xs-5 control-label">Uploader</label><div class="col-xs-7"><p data-hook="upload-user" class="form-control-static">loading...</p></div></div></div><div style="margin-bottom: 0px; padding-bottom: 0px;" class="panel-body"><div role="alert" id="subject-alert" class="alert alert-danger"><strong>Missing Subject!&nbsp;</strong>You must select or create the subject that these ABR belong to.</div><div class="row"><div class="col-lg-6 col-md-12"><div data-hook="subject-select"></div></div><div class="col-lg-6 col-md-12"><div data-hook="experiments-select"></div></div></div><div role="alert" style="display: none;" id="sets-alert" class="alert alert-danger"><strong>No Sets Selected!&nbsp;</strong>You must select at least one set, in one group to upload to the system.</div></div><div data-hook="groups-display" style="margin-top: 0px; padding-top: 0px;" class="panel-body"></div><div class="panel-footer"><button data-hook="cancel" class="btn btn-default">Cancel</button>&nbsp;&nbsp;<button data-hook="next" class="btn btn-primary">Next Step</button></div><div tabindex="-1" role="dialog" aria-hidden="true" id="leaveModal" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><h4 class="modal-title">Are You Sure?</h4></div><div class="modal-body"><p>Any and all work done on importing this ABR will be lost. You will have to start the process from the beginning if you leave now.</p></div><div class="modal-footer"><button data-dismiss="modal" class="btn btn-default">No, take me back.</button><button id="modalQuit" class="btn btn-primary">Yes i\'m sure.</button></div></div></div></div></div>';
    };

    // views\upload\unkownFile.jade compiled template
    templatizer["views"]["upload"]["unkownFile"] = function tmpl_views_upload_unkownFile() {
        return '<div class="panel panel-default"><div class="panel-heading"><h4 class="panel-title">Unknown Format</h4></div><div class="panel-body"><p>The signature of the file you have selected is unknown. It may not be supported.</p><textarea cols="55" data-hook="lines-dump"></textarea></div></div>';
    };

    return templatizer;
}));