this["JST"] = this["JST"] || {};

this["JST"]["test"] = function template(locals) {
var buf = [];
var jade_mixins = {};
var jade_interp;
;var locals_for_with = (locals || {});(function (squid) {
buf.push("<div id=\"yes\" class=\"hello\">YOU</div><div class=\"mouse\">" + (jade.escape((jade_interp = squid) == null ? '' : jade_interp)) + "</div>");}.call(this,"squid" in locals_for_with?locals_for_with.squid:typeof squid!=="undefined"?squid:undefined));;return buf.join("");
};