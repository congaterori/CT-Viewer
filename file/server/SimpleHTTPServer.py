#!/usr/bin/env python

"""Extend Python's built in HTTP server to save files

curl or wget can be used to send files with options similar to the following

  curl -X PUT --upload-file somefile.txt http://localhost:80
  wget -O- --method=PUT --body-file=somefile.txt http://localhost:80/somefile.txt

__Note__: curl automatically appends the filename onto the end of the URL so
the path can be omitted.

"""
import os
import subprocess
from os import system
system("title " + "httpserver")
try:
	import http.server as server
except ImportError as e:
	print(e)
	# Handle Python 2.x
	import SimpleHTTPServer as server

Ip = subprocess.Popen("for /f \"tokens=4\" %a in ('route print^|find \" 0.0.0.0\"') do @(echo %a)",stdout=subprocess.PIPE,shell=True).stdout.read().decode("utf-8")[:-2]
print("Local IP address:"+Ip)

class HTTPRequestHandler(server.SimpleHTTPRequestHandler):
	"""Extend SimpleHTTPRequestHandler to handle PUT requests"""
	def do_PUT(self):
		"""Save a file following a HTTP PUT request"""
		filename = os.path.basename(self.path)
		print("Hey")
		print(self.path)
		print(filename)
		print("HO")
		# Don't overwrite files
		if os.path.exists(filename):
			self.send_response(409, 'Conflict')
			self.end_headers()
			reply_body = '"%s" already exists\n' % filename
			self.wfile.write(reply_body.encode('utf-8'))
			return

		file_length = int(self.headers['Content-Length'])
		with open(filename, 'wb') as output_file:
			output_file.write(self.rfile.read(file_length))
		self.send_response(201, 'Created')
		self.end_headers()
		reply_body = 'Saved "%s"\n' % filename
		self.wfile.write(reply_body.encode('utf-8'))
	def do_POST(self):
		"""Save a file following a HTTP PUT request"""
		filename = os.path.basename(self.path)
		
		if os.path.exists(filename):
			os.system('del /f '+filename)
			self.send_response(200, 'OK')
			self.end_headers()
			reply_body = 'File already existed. Deleted it.'
			self.wfile.write(reply_body.encode('utf-8'))

		file_length = int(self.headers['Content-Length'])
		with open(filename, 'wb') as output_file:
			output_file.write(self.rfile.read(file_length))
		self.send_response(201, 'Created')
		self.end_headers()
		reply_body = 'Saved "%s"\n' % filename
		self.wfile.write(reply_body.encode('utf-8'))

if __name__ == '__main__':
	server.test(HandlerClass=HTTPRequestHandler,bind='localhost',port=80)