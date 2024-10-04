#Start Docker with gcloud
See gcp-start

#Get all GCP resources
See get-res.sh

#history
    2  gcloud projects list
    3  gcloud config list
   11  gcloud config set core/project  bamboo-pact-437204-b6
   12  gcloud compute instances list
   13  for i in {1..10}; do   gcloud compute instances create instance-$i     --zone="asia-south1-a"     --machine-type="e2-medium"     --image-family="$YOUR_IMAGE_FAMILY"     --image-project="$YOUR_IMAGE_PROJECT"; done
