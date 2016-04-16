const config = require('config')
const httpProxy = require('http-proxy')
const http = require('http')
const _ = require('lodash')

console.log("openabr proxy service starting...")

//Create basic proxy server for forwarding
const proxy = httpProxy.createProxyServer({})

//Create http server to listen for external requests
const server = http.createServer( function(req, res) {
  //show incoming routes
  console.log(req.url)
    
  //Route to correct endpoint for user and admin applications and databases
  if (_.startsWith(req.url, "/admin")) {

    //Admin-Portal server access
    if (_.startsWith(req.url, "/admin/data")) {
      req.url = req.url.replace("/admin/data",'');
      return proxy.web(req,res,{target: config.proxy.target.server})
    }

    //Admin-Portal
    if (req.url == "/admin" || req.url == "/admin/" || _.startsWith(req.url, "/admin/statics")) {
      //Static files like first page
      req.url = req.url.replace("/admin",'');
      return proxy.web(req, res, {target: config.proxy.target.admin});
    }

    //307 redirect + location for browser to load
    res.writeHead(307, {location: req.url.replace("/admin", "/admin#")})
    return res.end("openabr redirect")

  } else {

    //User-Portal database access
    if (_.startsWith(req.url, "/data")) {
      req.url = req.url.replace("/data",'');
      return proxy.web(req,res,{target: config.proxy.target.admin})
    }

    //User-Portal
    if (req.url == "" || req.url == "/" || _.startsWith(req.url, "/statics")) {
      //Static files like first page
      return proxy.web(req, res, {target: config.proxy.target.user});
    }

    //307 redirect + location for browser to load
    res.writeHead(307, {location: req.url.replace("/", "/#")})
    return res.end("openabr redirect")
  }
})

console.log(`openabr proxy service listening on port ${config.proxy.port}`)
server.listen(config.proxy.port)
