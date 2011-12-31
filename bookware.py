#!/usr/bin/env python
#

import os
import urllib

from google.appengine.ext import blobstore
from google.appengine.ext import webapp
from google.appengine.ext.webapp import blobstore_handlers
from google.appengine.ext.webapp import template
from google.appengine.ext.webapp.util import run_wsgi_app

class AddFileHandler(webapp.RequestHandler):
    def get(self):
        upload_url = blobstore.create_upload_url('/admin/upload')
        body = """
              <form action="%s" method="POST" enctype="multipart/form-data">
                Upload File:  
                <input type="file" name="file"><br/> 
                <input type="submit" name="submit" value="Upload"> 
              </form>
        """ % upload_url
        self.response.out.write(template.render('template.html', {'body': body}))

class UploadHandler(blobstore_handlers.BlobstoreUploadHandler):
    def post(self):
        upload_files = self.get_uploads('file')  # 'file' is file upload field in the form
        blob_info = upload_files[0]
        body = """
          <h3>Uploaded file '%s' (%d bytes) as /files/%s</h3>
          <p>
            <a href="/admin/add">Add another</a> | <a href="/">List</a>
          </p>
        """  % (blob_info.filename, blob_info.size, blob_info.key())
        self.response.out.write(template.render('template.html', {'body': body}))

class ListHandler(webapp.RequestHandler):
    def get(self):
        self.response.out.write(template.render('index.html', {'blobs': blobstore.BlobInfo.all() }))

class ServeHandler(blobstore_handlers.BlobstoreDownloadHandler):
    def get(self, resource):
        resource = str(urllib.unquote(resource))
        blob_info = blobstore.BlobInfo.get(resource)
        self.send_blob(blob_info)

def main():
    application = webapp.WSGIApplication(
          [('/admin/add', AddFileHandler),
           ('/admin/upload', UploadHandler),
           ('/files/?$', ListHandler),
           ('/?$', ListHandler),
           ('/files/([^/]+)?', ServeHandler),
          ], debug=True)
    run_wsgi_app(application)

if __name__ == '__main__':
  main()
