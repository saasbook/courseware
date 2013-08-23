#!/usr/bin/env python
#

import urllib
import logging

from google.appengine.ext import blobstore
from google.appengine.ext import webapp
from google.appengine.ext.webapp import blobstore_handlers
from google.appengine.ext.webapp import template
from google.appengine.ext.webapp.util import run_wsgi_app
from google.appengine.api.users import is_current_user_admin

class UploadHandler(blobstore_handlers.BlobstoreUploadHandler):
    def post(self):
        upload_files = self.get_uploads('file')  # 'file' is file upload field in the form
        blob_info = upload_files[0]
        self.redirect('/')

class DeleteHandler(webapp.RequestHandler):
    def post(self, urlpath):
        blobname = urllib.unquote(urlpath)
        logging.debug("Deleting " + blobname)
        blobstore.delete(blobname)
        self.redirect('/')

class ListHandler(webapp.RequestHandler):
    def get(self):
        upload_url = blobstore.create_upload_url('/admin/upload')
        params = {'admin': is_current_user_admin(), 
                  'upload_url': upload_url, 
                  'blobs': blobstore.BlobInfo.all() }
        self.response.out.write(template.render('index.html', params))

class ServeHandler(blobstore_handlers.BlobstoreDownloadHandler):
    def get(self, resource):
        resource = str(urllib.unquote(resource))
        blob_info = blobstore.BlobInfo.get(resource)
        self.send_blob(blob_info, save_as=True)

def main():
    logging.getLogger().setLevel(logging.DEBUG)
    application = webapp.WSGIApplication(
          [('/admin/upload', UploadHandler),
           ('/admin/delete/(.*)$', DeleteHandler),
           ('/files/?$', ListHandler),
           ('/?$', ListHandler),
           ('/files/([^/]+)?', ServeHandler),
          ], debug=True)
    run_wsgi_app(application)

if __name__ == '__main__':
  main()
