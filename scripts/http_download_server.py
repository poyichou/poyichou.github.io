'''
download FILENAME whenever GET
'''
try:
    import http.server as BaseHTTPServer  # Python 3.x
except ImportError:
    import BaseHTTPServer  # Python 2.x
import os
import shutil
import sys

if len(sys.argv) < 2:
    print('usage: python {} <share file> [port]'.format(__file__))
    exit()

FILEPATH = os.path.abspath(sys.argv[1])
FILENAME = os.path.basename(FILEPATH)

if os.path.isdir(FILEPATH): # folder, send zipped file instead
    import zipfile
    ZIP_PATH = '/tmp/{}.zip'.format(FILENAME)
    with zipfile.ZipFile(ZIP_PATH, 'w', zipfile.ZIP_DEFLATED) as zf:
        for root, dirs, files in os.walk(FILEPATH):
            for file_name in files:
                zf.write(os.path.join(root, file_name), '{}/{}'.format(FILENAME, file_name))

    FILENAME = os.path.basename(ZIP_PATH)
    FILEPATH = ZIP_PATH



PORT = 7000 if len(sys.argv) < 3 else int(sys.argv[2])

class HTTPRequestHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_GET(self):
        with open(FILEPATH, 'rb') as f:
            self.send_response(200)
            self.send_header("Content-Type", 'application/zip')
            self.send_header("Content-Disposition", 'filename="{}"'.format(FILENAME.encode("utf-8").decode("latin1")))
            self.end_headers()
            shutil.copyfileobj(f, self.wfile)

def test(HandlerClass=HTTPRequestHandler,
         ServerClass=BaseHTTPServer.HTTPServer,
         protocol="HTTP/1.0"):
    server_address = ('', PORT)

    HandlerClass.protocol_version = protocol
    httpd = BaseHTTPServer.HTTPServer(server_address, HandlerClass)

    sa = httpd.socket.getsockname()
    print("Serving HTTP on {0[0]} port {0[1]} ... {1}".format(sa, FILENAME))
    try:
        httpd.serve_forever()
    except KeyboardInterrupt as e:
        pass

if __name__ == '__main__':
    test()
