'''
download FILEPATH whenever GET
'''
try:
    import http.server as BaseHTTPServer  # Python 3.x
except ImportError:
    import BaseHTTPServer  # Python 2.x
import os
import shutil
import sys

if len(sys.argv) < 2:
    print(f'usage: python {__file__} <share file> [port]')
    exit()
elif '/' not in sys.argv[1]:
    FILEPATH = sys.argv[1]
else:
    FILEPATH = sys.argv[1].split('/')[-1]

PORT = 7000 if len(sys.argv) < 3 else int(sys.argv[2])

class HTTPRequestHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_GET(self):
        with open(FILEPATH, 'rb') as f:
            self.send_response(200)
            self.send_header("Content-Type", 'application/zip')
            self.send_header("Content-Disposition", f'filename="{FILEPATH.encode("utf-8").decode("latin1")}"')
            self.end_headers()
            shutil.copyfileobj(f, self.wfile)

def test(HandlerClass=HTTPRequestHandler,
         ServerClass=BaseHTTPServer.HTTPServer,
         protocol="HTTP/1.0"):
    server_address = ('', PORT)

    HandlerClass.protocol_version = protocol
    httpd = BaseHTTPServer.HTTPServer(server_address, HandlerClass)

    sa = httpd.socket.getsockname()
    print("Serving HTTP on {0[0]} port {0[1]} ... {1}".format(sa, FILEPATH))
    try:
        httpd.serve_forever()
    except KeyboardInterrupt as e:
        pass

if __name__ == '__main__':
    test()
