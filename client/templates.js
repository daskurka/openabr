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
    var jade=function(){function r(r){return null!=r&&""!==r}function n(e){return Array.isArray(e)?e.map(n).filter(r).join(" "):e}var e={};return e.merge=function t(n,e){if(1===arguments.length){for(var a=n[0],s=1;s<n.length;s++)a=t(a,n[s]);return a}var i=n["class"],l=e["class"];(i||l)&&(i=i||[],l=l||[],Array.isArray(i)||(i=[i]),Array.isArray(l)||(l=[l]),n["class"]=i.concat(l).filter(r));for(var o in e)"class"!=o&&(n[o]=e[o]);return n},e.joinClasses=n,e.cls=function(r,t){for(var a=[],s=0;s<r.length;s++)a.push(t&&t[s]?e.escape(n([r[s]])):n(r[s]));var i=n(a);return i.length?' class="'+i+'"':""},e.attr=function(r,n,t,a){return"boolean"==typeof n||null==n?n?" "+(a?r:r+'="'+r+'"'):"":0==r.indexOf("data")&&"string"!=typeof n?" "+r+"='"+JSON.stringify(n).replace(/'/g,"&apos;")+"'":t?" "+r+'="'+e.escape(n)+'"':" "+r+'="'+n+'"'},e.attrs=function(r,t){var a=[],s=Object.keys(r);if(s.length)for(var i=0;i<s.length;++i){var l=s[i],o=r[l];"class"==l?(o=n(o))&&a.push(" "+l+'="'+o+'"'):a.push(e.attr(l,o,!1,t))}return a.join("")},e.escape=function(r){var n=String(r).replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;");return n===""+r?r:n},e.rethrow=function a(r,n,e,t){if(!(r instanceof Error))throw r;if(!("undefined"==typeof window&&n||t))throw r.message+=" on line "+e,r;try{t=t||require("fs").readFileSync(n,"utf8")}catch(s){a(r,null,e)}var i=3,l=t.split("\n"),o=Math.max(e-i,0),c=Math.min(l.length,e+i),i=l.slice(o,c).map(function(r,n){var t=n+o+1;return(t==e?"  > ":"    ")+t+"| "+r}).join("\n");throw r.path=n,r.message=(n||"Jade")+":"+e+"\n"+i+"\n\n"+r.message,r},e}();

    var templatizer = {};
    templatizer["includes"] = {};
    templatizer["pages"] = {};
    templatizer["includes"]["form"] = {};
    templatizer["includes"]["items"] = {};
    templatizer["includes"]["navbar"] = {};
    templatizer["pages"]["admin"] = {};
    templatizer["pages"]["profile"] = {};
    templatizer["pages"]["subjects"] = {};
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
        return '<tr data-hook="field-row"><td data-hook="name"></td><td data-hook="type"></td><td data-hook="dbName"></td><td data-hook="required"></td><td data-hook="creator"></td><td data-hook="description"></td></tr>';
    };

    // includes\items\fixedDataField.jade compiled template
    templatizer["includes"]["items"]["fixedDataField"] = function tmpl_includes_items_fixedDataField() {
        return '<tr data-hook="fixed-field-row"><td data-hook="name"></td><td data-hook="type"></td><td data-hook="dbName"></td><td data-hook="required"></td><td data-hook="description"></td></tr>';
    };

    // includes\items\subject.jade compiled template
    templatizer["includes"]["items"]["subject"] = function tmpl_includes_items_subject() {
        return '<tr data-hook="subject-row"><td data-hook="reference"></td><td data-hook="strain"></td><td data-hook="species"></td><td data-hook="dob"></td><td data-hook="dod"></td><td data-hook="researcher"></td><td data-hook="experiments"></td></tr>';
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
        return '<div><h2>Fields Administration&nbsp;<small>Help</small></h2><ul class="nav nav-pills"><li role="presentation" class="active"><a href="/admin/fields">Help</a></li><li role="presentation"><a href="/admin/fields/subject">Subject</a></li><li role="presentation"><a href="/admin/fields/experiment">Experiment</a></li><li role="presentation"><a href="/admin/fields/abr">ABR</a></li><li role="presentation"><a href="/admin/fields/abr-group">ABR Group</a></li><li role="presentation"><a href="/admin/fields/abr-set">ABR Set</a></li><li role="presentation"><a href="/admin/fields/abr-reading">ABR Reading</a></li></ul><p>The fillowing section will eventually explain how all of this fields marlarky works, not today bob.</p></div>';
    };

    // pages\admin\fields\list.jade compiled template
    templatizer["pages"]["admin"]["fields"]["list"] = function tmpl_pages_admin_fields_list() {
        return '<div><h2>Fields Administration&nbsp;<small data-hook="collection-name"></small></h2><ul data-hook="fields-nav" class="nav nav-pills"><li role="presentation"><a href="/admin/fields">Help</a></li><li role="presentation" class="subject-li"><a href="/admin/fields/subject">Subject</a></li><li role="presentation" class="experiment-li"><a href="/admin/fields/experiment">Experiment</a></li><li role="presentation" class="abr-li"><a href="/admin/fields/abr">ABR</a></li><li role="presentation" class="abr-group-li"><a href="/admin/fields/abr-group">ABR Group</a></li><li role="presentation" class="abr-set-li"><a href="/admin/fields/abr-set">ABR Set</a></li><li role="presentation" class="abr-reading-li"><a href="/admin/fields/abr-reading">ABR Reading</a></li></ul><hr/><h3>Fixed Fields</h3><table class="table table-hover"><thead><th>Name</th><th>Type</th><th>Database Name</th><th>Required</th><th>Description</th></thead><tbody data-hook="fixed-fields-table"></tbody></table><hr/><h3>User Fields&nbsp;<small><button data-hook="add-user-field" class="btn btn-primary btn-sm">Add new</button></small></h3><table class="table table-hover"><thead><th>Name</th><th>Type</th><th>Database Name</th><th>Required</th><th>Creator</th><th>Description</th></thead><tbody data-hook="fields-table"></tbody></table></div>';
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

    // pages\subjects\detail.jade compiled template
    templatizer["pages"]["subjects"]["detail"] = function tmpl_pages_subjects_detail() {
        return '<div class="container"><div class="col-md-offset-2 col-md-8"><h2>Subject Detail</h2><form data-hook="subject-form"><fieldset data-hook="field-container"></fieldset><div class="btn-group"><button data-hook="reset" type="submit" class="btn btn-primary">Update</button><button data-hook="cancel" type="button" class="btn btn-default">Cancel</button></div></form></div></div>';
    };

    // pages\subjects\index.jade compiled template
    templatizer["pages"]["subjects"]["index"] = function tmpl_pages_subjects_index() {
        return '<div class="container"><h2>Subjects</h2><div class="row"><div class="col-sm-9"><input data-hook="filter" class="form-control"/></div><div class="col-sm-3"><button id="newSubject" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span>&nbsp;new subject</button></div></div><hr/><table class="table table-hover"><thead><th>Ref</th><th>Strain</th><th>Species</th><th>DOB</th><th>DOD</th><th>Researcher</th><th>Experiments</th></thead><tbody data-hook="subjects-table"></tbody></table><hr/><div data-hook="pagination-control" class="row"></div></div>';
    };

    return templatizer;
}));