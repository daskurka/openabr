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
    templatizer["pages"]["admin"]["users"] = {};

    // body.jade compiled template
    templatizer["body"] = function tmpl_body() {
        return '<body><div class="navbar-container"></div><div class="container"><main data-hook="page-container"></main></div></body>';
    };

    // head.jade compiled template
    templatizer["head"] = function tmpl_head() {
        return '<meta charset="utf-8"/><meta http-equiv="X-UA-Compatible" content="IE=edge"/><meta name="viewport" content="width=device-width, initial-scale=1"/><meta name="description" content="OpenABR Site"/><meta name="author" content="Sam Kirkpatrick"/><link rel="icon" href="/img/favicon.ico"/><title>OpenABR</title>';
    };

    // includes\form\input.jade compiled template
    templatizer["includes"]["form"]["input"] = function tmpl_includes_form_input() {
        return '<div class="form-group"><label data-hook="label"></label><div data-hook="message-container"><div data-hook="message-text" class="alert alert-danger"></div></div><input class="form-control"/></div>';
    };

    // includes\form\password.jade compiled template
    templatizer["includes"]["form"]["password"] = function tmpl_includes_form_password() {
        return '<div class="form-group"><label data-hook="label"></label><div data-hook="message-container"><div data-hook="message-text" class="alert alert-danger"></div></div><input data-hook="password-input" type="password" class="form-control"/><label data-hook="label-confirm"></label><input data-hook="password-input-confirm" type="password" class="form-control"/></div>';
    };

    // includes\form\users.jade compiled template
    templatizer["includes"]["form"]["users"] = function tmpl_includes_form_users() {
        return '<div class="form-group"><label data-hook="label"></label><div data-hook="message-container"><div data-hook="message-text" class="alert alert-danger"></div></div><input class="form-control"/></div>';
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
                buf.push('<li class="dropdown"><a href="#" data-toggle="dropdown" class="dropdown-toggle">Admin&nbsp;<span class="caret"></span></a><ul role="menu" class="dropdown-menu"><li><a href="/admin/users">Users</a></li></ul></li>');
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

    // pages\404.jade compiled template
    templatizer["pages"]["404"] = function tmpl_pages_404() {
        return '<div class="container"><h2>404<small>&nbsp;Gah! That was not supposed to happen</small></h2><p>There is nothing currently at this link address! Maybe you mistyped or copied a bad one.</p><p>Don\'t panic and remain calm, use the navbar above to go somewhere safe!</p><p>Oh, and if this continues to happen&nbsp;<a href="/contact">contact the admin!</a></p></div>';
    };

    // pages\about.jade compiled template
    templatizer["pages"]["about"] = function tmpl_pages_about() {
        return '<div class="container"><h2>About OpenABR</h2><img src="/img/abrexample.png" alt="Example of ABR waveform" class="img-rounded"/><p>OpenABR is an cloud-hosted tool for storing and analysing Auditory Brainstem Response (ABR) data. Its purpose is to provide hearing researchers faster collection and analysis of ABRs. Additionalty it is hoped that by collecting various ABRS from other organisations and pooling the data better models and analysis processes can be developed.</p><p>OpenABR was originally created by Samuel Kirkpatrick for the Ryugo Lab based at the Garvin Institute, Sydney Australia, as part of a Master of Engineering degree at University of Technology, Sydney (UTS). It is currently being developed with the goal of becoming an open-source self-sustaining tool for researchers.</p><p>Interested? Please see the&nbsp;<a href="contact">contact page</a>&nbsp;for more infomation.</p></div>';
    };

    // pages\admin\users\create.jade compiled template
    templatizer["pages"]["admin"]["users"]["create"] = function tmpl_pages_admin_users_create() {
        return '<div class="container"><h2>Create User</h2><form data-hook="user-form"><fieldset data-hook="field-container"></fieldset><div class="alert alert-info"><strong>Please Note&nbsp;</strong>A password will be automatically generated and displayed post submission.</div><div class="buttons"><button data-hook="reset" type="submit" class="btn">Submit</button></div></form></div>';
    };

    // pages\admin\users\edit.jade compiled template
    templatizer["pages"]["admin"]["users"]["edit"] = function tmpl_pages_admin_users_edit() {
        return '<div class="container"><h2>Edit User</h2><form data-hook="user-form"><fieldset data-hook="field-container"></fieldset><div class="buttons"><button data-hook="reset" type="submit" class="btn">Submit</button><button data-hook="delete" type="button" class="btn btn-danger">Delete</button></div></form></div>';
    };

    // pages\admin\users\password.jade compiled template
    templatizer["pages"]["admin"]["users"]["password"] = function tmpl_pages_admin_users_password() {
        return '<div class="panel panel-info"><div class="panel-heading"><div class="panel-title"><span class="glyphicon glyphicon-lock"></span>&nbsp;Generated Password</div></div><div class="panel-body"><strong>Please ensure that the user changes this password as soon as possibile.</strong><hr/><div class="row"><div class="col-xs-2"><strong>Name:</strong></div><div data-hook="name" class="col-xs-10"></div></div><div class="row"><div class="col-xs-2"><strong>Email:</strong></div><div data-hook="email" class="col-xs-10"></div></div><div class="row"><div class="col-xs-2"><strong>Password:</strong></div><div data-hook="password" class="col-xs-10"></div></div></div><div class="panel-footer"><button id="copyToClipboard" class="btn btn-default"><span class="glyphicon glyphicon-paperclip"></span>Copy to clipboard</button></div></div>';
    };

    // pages\admin\users\users.jade compiled template
    templatizer["pages"]["admin"]["users"]["users"] = function tmpl_pages_admin_users_users() {
        return '<div class="container"><h2>Users</h2><div class="row"><div class="col-sm-9"><input data-hook="filter" class="form-control"/></div><div class="col-sm-3"><button id="newUser" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span>&nbsp;new user</button></div></div><hr/><table class="table table-hover"><thead><td>Name</td><td>Email</td><td>Position</td></thead><tbody data-hook="users-table"></tbody></table><hr/><div data-hook="pagination-control" class="row"></div></div>';
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

    // pages\status.jade compiled template
    templatizer["pages"]["status"] = function tmpl_pages_status() {
        return '<div class="container"><h2>Welcome to OpenABR</h2><p>You are logged in!</p></div>';
    };

    return templatizer;
}));