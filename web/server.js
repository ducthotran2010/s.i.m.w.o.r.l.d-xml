var http = require('http');
var fs = require('fs');

const port = 7777;

http.createServer(function (req, res) {
  fs.readFile('index.jsp', function (err, data) {
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.write(data);
    res.end();
  });

  console.log(req.url);
    if (req.url.indexOf('.js') !== -1 || req.url.indexOf('.css') !== -1)
    fs.readFile(req.url, function (err, data) {
      res.writeHead(200, { 'Content-Type': 'text/html' });
      res.write(data);
      res.end();
    });
}).listen(port);
console.log(`Server is on at http://localhost:${port}`);
