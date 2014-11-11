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
    templatizer["includes"]["navbar"] = {};

    // body.jade compiled template
    templatizer["body"] = function tmpl_body() {
        return '<body><div class="navbar-container"></div><div class="container"><main data-hook="page-container"></main></div></body>';
    };

    // includes\form\input.jade compiled template
    templatizer["includes"]["form"]["input"] = function tmpl_includes_form_input() {
        return '<div class="form-group"><label data-hook="label"></label><div data-hook="message-container"><div data-hook="message-text" class="alert alert-danger"></div></div><input class="form-control"/></div>';
    };

    // includes\navbar\loggedin.jade compiled template
    templatizer["includes"]["navbar"]["loggedin"] = function tmpl_includes_navbar_loggedin(locals) {
        var buf = [];
        var jade_mixins = {};
        var jade_interp;
        var locals_for_with = locals || {};
        (function(currentAccount, otherAccounts, isSystemAdmin, name) {
            buf.push('<div class="navbar-header"><a' + jade.attr("href", "/" + currentAccount.urlName + "", true, false) + ' class="navbar-brand">OpenABR</a></div><ul class="nav navbar-nav"><li><a' + jade.attr("href", "/" + currentAccount.urlName + "/process", true, false) + ">Upload ABR</a></li><li><a" + jade.attr("href", "/" + currentAccount.urlName + "/query", true, false) + ">Query ABRs</a></li><li><a" + jade.attr("href", "/" + currentAccount.urlName + "/experiments", true, false) + ">Experiments</a></li><li><a" + jade.attr("href", "/" + currentAccount.urlName + "/subjects", true, false) + '>Subjects</a></li></ul><ul class="nav navbar-nav navbar-right"><li class="dropdown"><a href="#" data-toggle="dropdown" class="dropdown-toggle">' + jade.escape((jade_interp = currentAccount.name) == null ? "" : jade_interp) + '&nbsp;<span class="caret"></span></a><ul role="menu" class="dropdown-menu"><li><a' + jade.attr("href", "/" + currentAccount.urlName + "", true, false) + ">View</a></li>");
            if (currentAccount.isAdmin) {
                buf.push("<li><a" + jade.attr("href", "/" + currentAccount.urlName + "/manage", true, false) + ">Manage</a></li>");
            }
            if (otherAccounts.length > 0) {
                buf.push('<li class="divider"></li>');
                (function() {
                    var $obj = otherAccounts;
                    if ("number" == typeof $obj.length) {
                        for (var $index = 0, $l = $obj.length; $index < $l; $index++) {
                            var account = $obj[$index];
                            buf.push("<li><a" + jade.attr("href", "/" + account.urlName + "", true, false) + ">" + jade.escape((jade_interp = account.name) == null ? "" : jade_interp) + "</a></li>");
                        }
                    } else {
                        var $l = 0;
                        for (var $index in $obj) {
                            $l++;
                            var account = $obj[$index];
                            buf.push("<li><a" + jade.attr("href", "/" + account.urlName + "", true, false) + ">" + jade.escape((jade_interp = account.name) == null ? "" : jade_interp) + "</a></li>");
                        }
                    }
                }).call(this);
            }
            buf.push("</ul></li>");
            if (isSystemAdmin) {
                buf.push('<li><a href="/admin/accounts">Accounts</a></li>');
            }
            buf.push('<li><a href="/logout">Logout</a></li></ul><p class="navbar-text navbar-right"><a href="/profile">' + jade.escape((jade_interp = name) == null ? "" : jade_interp) + "</a></p>");
        }).call(this, "currentAccount" in locals_for_with ? locals_for_with.currentAccount : typeof currentAccount !== "undefined" ? currentAccount : undefined, "otherAccounts" in locals_for_with ? locals_for_with.otherAccounts : typeof otherAccounts !== "undefined" ? otherAccounts : undefined, "isSystemAdmin" in locals_for_with ? locals_for_with.isSystemAdmin : typeof isSystemAdmin !== "undefined" ? isSystemAdmin : undefined, "name" in locals_for_with ? locals_for_with.name : typeof name !== "undefined" ? name : undefined);
        return buf.join("");
    };

    // includes\navbar\loggedout.jade compiled template
    templatizer["includes"]["navbar"]["loggedout"] = function tmpl_includes_navbar_loggedout() {
        return '<div class="navbar-header"><a href="/" class="navbar-brand">OpenABR</a></div><ul class="nav navbar-nav navbar-right"><li><a href="/login">Login</a></li><li><a href="/contact">Contact</a></li><li><a href="/about">About</a></li></ul>';
    };

    // navbar.jade compiled template
    templatizer["navbar"] = function tmpl_navbar() {
        return '<nav class="navbar navbar-default navbar-inverse"><div class="container-fluid navbar-content"></div></nav>';
    };

    // pages\about.jade compiled template
    templatizer["pages"]["about"] = function tmpl_pages_about() {
        return "<p>Hi, I am the about page!</p>";
    };

    // pages\contact.jade compiled template
    templatizer["pages"]["contact"] = function tmpl_pages_contact() {
        return "<p>Hi, I am the contact page!</p>";
    };

    // pages\home.jade compiled template
    templatizer["pages"]["home"] = function tmpl_pages_home() {
        return '<div class="container"><p>Welcome to the OpenABR Site</p><a href="about">About</a><a href="contact">Contact</a><a href="login">Login</a></div>';
    };

    // pages\login.jade compiled template
    templatizer["pages"]["login"] = function tmpl_pages_login() {
        return '<div class="container"><form role="form" class="form-signin"><h2 class="form-signin-heading">Please sign in</h2><input id="emailAddress" type="email" placeholder="Email Address" required="required" autofocus="autofocus" class="form-control"/><input id="password" type="password" placeholder="Password" required="required" class="form-control"/><div class="checkbox"><label><input type="checkbox" value="remember-me"/>&nbsp;Remember me</label></div><button id="submitButton" type="button" class="btn btn-lg btn-primary btn-block"># Sign in</button></form></div>';
    };

    return templatizer;
}));