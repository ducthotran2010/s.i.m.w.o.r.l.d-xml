
var http = require('http');
var fs = require('fs');
http.createServer(function (req, res) {
    fs.readFile('simsodep.test.xml', function(err, data) {
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.write(data);
        res.end();
    });
    console.log("Server is listening on http://localhost:8080");
}).listen(8080);

