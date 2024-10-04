docker run -ti -e CLOUDSDK_CONFIG=/config/mygcloud \
              -v `pwd`/gcp/mygcloud:/config/mygcloud \
              -v `pwd`/gcp:/certs  gcr.io/google.com/cloudsdktool/google-cloud-cli:stable /bin/bash  
