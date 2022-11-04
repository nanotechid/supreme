/*
* Proxy Bridge
* Copyright PANCHO7532 - P7COMUnications LLC (c) 2021
* Dedicated to Emanuel Miranda, for giving me the idea to make this :v
*/
const net = require('net');
const stream = require('stream');
const util = require('util');
var dhost = "127.0.0.1";
var dport = "";
var mainPort = "";
var outputFile = "outputFile.txt";
var packetsToSkip = 0;
var gcwarn = true;
for(c = 0; c < process.argv.length; c++) {
    switch(process.argv[c]) {
        case "-skip":
            packetsToSkip = process.argv[c + 1];
            break;
        case "-dhost":
            dhost = process.argv[c + 1];
            break;
        case "-dport":
            dport = process.argv[c + 1];
            break;
        case "-mport":
            mainPort = process.argv[c + 1];
            break;
        case "-o":
            outputFile = process.argv[c + 1];
            break;
    }
}
function gcollector() {
    if(!global.gc && gcwarn) {
        console.log("[WARNING] Garbage Collector isn't enabled! Memory leaks may occur.");
        gcwarn = false;
        return;
    } else if(global.gc) {
        global.gc();
        return;
    } else {
        return;
    }
}
function parseRemoteAddr(raddr) {
    if(raddr.toString().indexOf("ffff") != -1) {
        //is IPV4 address
        return raddr.substring(7, raddr.length);
    } else {
        return raddr;
    }
}
setInterval(gcollector, 1000);
const server = net.createServer();
server.on('connection', function(socket) {
    var packetCount = 0;
    //var handshakeMade = false;
    socket.write("HTTP/1.1 101 AUTOSCRIPT BY ENVY VPN\r\nContent-Length: 1048576000000\r\n\r\n", function(err) {
        if(err) {
            console.log("[SWRITE] Failed to write response to " + socket.remoteAddress + ":" + socket.remotePort + ", error: " + err);
        }
    });
    console.log("[INFO] Connection received from " + socket.remoteAddress + ":" + socket.remotePort);
    var conn = net.createConnection({host: dhost, port: dport});
    socket.on('data', function(data) {
        //pipe sucks
        if(packetCount < packetsToSkip) {
            //console.log("---c1");
            packetCount++;
        } else if(packetCount == packetsToSkip) {
            //console.log("---c2");
            conn.write(data, function(err) {
                if(err) {
                    console.log("[EWRITE] Failed to write to external socket! - " + err);
                }
            });
        }
        if(packetCount > packetsToSkip) {
            //console.log("---c3");
            packetCount = packetsToSkip;
        }
        //conn.write(data);
    });
    conn.on('data', function(data) {
        //pipe sucks x2
        socket.write(data, function(err) {
            if(err) {
                console.log("[SWRITE2] Failed to write response to " + socket.remoteAddress + ":" + socket.remotePort + ", error: " + err);
            }
        });
    });
    socket.once('data', function(data) {
        /*
        * Nota para mas tarde, resolver que diferencia hay entre .on y .once
        */
    });
    socket.on('error', function(error) {
        console.log("[SOCKET] read " + error + " from " + socket.remoteAddress + ":" + socket.remotePort);
        conn.destroy();
    });
    conn.on('error', function(error) {
        console.log("[REMOTE] read " + error);
        socket.destroy();
    });
    socket.on('close', function() {
        console.log("[INFO] Connection terminated for " + socket.remoteAddress + ":" + socket.remotePort);
        conn.destroy();
    });
});
server.on("error", function(error) {
    console.log("[SRV] Error " + error + ", this may be unrecoverable");
});
server.on("close", function() {
    //conection closed idk, maybe i should not capture this
});
server.listen(mainPort, function(){
    console.log("[INFO] Server started on port: " + mainPort);
    console.log("[INFO] Redirecting requests to: " + dhost + " at port " + dport);
});
