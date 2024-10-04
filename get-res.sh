#!/bin/bash

# Temp files to store resource lists
temp_file=$(mktemp)

# Helper function to display resource count, handling zero cases and ignoring zero in the summary
count_resources() {
  local resource_name=$1
  local count=$2
  local actual_count=$((count - 1))
  
  if (( actual_count > 0 )); then
    echo "$resource_name: $actual_count" > /dev/stderr
    echo $actual_count
  else
    echo 0
  fi
}

# Helper function to check if a service is enabled
is_service_enabled() {
  local service_name=$1
  gcloud services list --enabled --format="value(config.name)" | grep -q "$service_name"
}

# Initialize total count
total_count=0

# Fetch and count resources for enabled services

if is_service_enabled "compute.googleapis.com"; then
  echo "Fetching Compute Engine instances..."
  gcloud compute instances list --format="table(name, zone, machineType, status)" > $temp_file
  cat $temp_file
  compute_instance_count=$(wc -l < $temp_file)
else
  compute_instance_count=1
fi
resource_count=$(count_resources "Compute Engine instances" $compute_instance_count)
total_count=$((total_count + resource_count))

if is_service_enabled "compute.googleapis.com"; then
  echo "Fetching VM snapshots..."
  gcloud compute snapshots list --format="table(name, diskSizeGb, status)" > $temp_file
  cat $temp_file
  snapshot_count=$(wc -l < $temp_file)
else
  snapshot_count=1
fi
resource_count=$(count_resources "VM snapshots" $snapshot_count)
total_count=$((total_count + resource_count))

if is_service_enabled "compute.googleapis.com"; then
  echo "Fetching Persistent Disks..."
  gcloud compute disks list --format="table(name, sizeGb, type, status)" > $temp_file
  cat $temp_file
  disk_count=$(wc -l < $temp_file)
else
  disk_count=1
fi
resource_count=$(count_resources "Persistent Disks" $disk_count)
total_count=$((total_count + resource_count))

if is_service_enabled "storage.googleapis.com"; then
  echo "Fetching Cloud Storage buckets..."
  gcloud storage buckets list --format="table(name, location, storageClass)" > $temp_file
  cat $temp_file
  bucket_count=$(wc -l < $temp_file)
else
  bucket_count=1
fi
resource_count=$(count_resources "Cloud Storage buckets" $bucket_count)
total_count=$((total_count + resource_count))

if is_service_enabled "container.googleapis.com"; then
  echo "Fetching Google Kubernetes Engine (GKE) clusters..."
  gcloud container clusters list --format="table(name, location, status)" > $temp_file
  cat $temp_file
  gke_cluster_count=$(wc -l < $temp_file)
else
  gke_cluster_count=1
fi
resource_count=$(count_resources "GKE clusters" $gke_cluster_count)
total_count=$((total_count + resource_count))

if is_service_enabled "sqladmin.googleapis.com"; then
  echo "Fetching Cloud SQL instances..."
  gcloud sql instances list --format="table(name, region, databaseVersion, settings.tier)" > $temp_file
  cat $temp_file
  sql_instance_count=$(wc -l < $temp_file)
else
  sql_instance_count=1
fi
resource_count=$(count_resources "Cloud SQL instances" $sql_instance_count)
total_count=$((total_count + resource_count))

#if is_service_enabled "bigquery.googleapis.com"; then
#  echo "Fetching BigQuery datasets..."
#  gcloud bigquery datasets list --format="table(datasetId, location)" > $temp_file
#  cat $temp_file
#  bigquery_dataset_count=$(wc -l < $temp_file)
#else
#  bigquery_dataset_count=1
#fi
#resource_count=$(count_resources "BigQuery datasets" $bigquery_dataset_count)
#total_count=$((total_count + resource_count))

if is_service_enabled "pubsub.googleapis.com"; then
  echo "Fetching Pub/Sub topics..."
  gcloud pubsub topics list --format="table(name)" > $temp_file
  cat $temp_file
  pubsub_topic_count=$(wc -l < $temp_file)
else
  pubsub_topic_count=1
fi
resource_count=$(count_resources "Pub/Sub topics" $pubsub_topic_count)
total_count=$((total_count + resource_count))

if is_service_enabled "pubsub.googleapis.com"; then
  echo "Fetching Pub/Sub subscriptions..."
  gcloud pubsub subscriptions list --format="table(name)" > $temp_file
  cat $temp_file
  pubsub_subscription_count=$(wc -l < $temp_file)
else
  pubsub_subscription_count=1
fi
resource_count=$(count_resources "Pub/Sub subscriptions" $pubsub_subscription_count)
total_count=$((total_count + resource_count))

if is_service_enabled "cloudfunctions.googleapis.com"; then
  echo "Fetching Cloud Functions..."
  gcloud functions list --format="table(name, runtime, status)" > $temp_file
  cat $temp_file
  cloud_function_count=$(wc -l < $temp_file)
else
  cloud_function_count=1
fi
resource_count=$(count_resources "Cloud Functions" $cloud_function_count)
total_count=$((total_count + resource_count))

if is_service_enabled "run.googleapis.com"; then
  echo "Fetching Cloud Run services..."
  gcloud run services list --format="table(service, region, status)" > $temp_file
  cat $temp_file
  cloud_run_count=$(wc -l < $temp_file)
else
  cloud_run_count=1
fi
resource_count=$(count_resources "Cloud Run services" $cloud_run_count)
total_count=$((total_count + resource_count))

if is_service_enabled "appengine.googleapis.com"; then
  echo "Fetching App Engine services..."
  gcloud app services list --format="table(id)" > $temp_file
  cat $temp_file
  app_engine_count=$(wc -l < $temp_file)
else
  app_engine_count=1
fi
resource_count=$(count_resources "App Engine services" $app_engine_count)
total_count=$((total_count + resource_count))

if is_service_enabled "redis.googleapis.com"; then
  echo "Fetching Memorystore instances (Redis)..."
  gcloud redis instances list --format="table(name, region, tier, memorySizeGb)" > $temp_file
  cat $temp_file
  memorystore_count=$(wc -l < $temp_file)
else
  memorystore_count=1
fi
resource_count=$(count_resources "Memorystore instances" $memorystore_count)
total_count=$((total_count + resource_count))

if is_service_enabled "spanner.googleapis.com"; then
  echo "Fetching Cloud Spanner instances..."
  gcloud spanner instances list --format="table(name, config, nodeCount)" > $temp_file
  cat $temp_file
  spanner_instance_count=$(wc -l < $temp_file)
else
  spanner_instance_count=1
fi
resource_count=$(count_resources "Cloud Spanner instances" $spanner_instance_count)
total_count=$((total_count + resource_count))

if is_service_enabled "dns.googleapis.com"; then
  echo "Fetching Cloud DNS managed zones..."
  gcloud dns managed-zones list --format="table(name, dnsName)" > $temp_file
  cat $temp_file
  dns_zone_count=$(wc -l < $temp_file)
else
  dns_zone_count=1
fi
resource_count=$(count_resources "Cloud DNS managed zones" $dns_zone_count)
total_count=$((total_count + resource_count))

if is_service_enabled "compute.googleapis.com"; then
  echo "Fetching Cloud VPN Gateways..."
  gcloud compute vpn-gateways list --format="table(name, region)" > $temp_file
  cat $temp_file
  vpn_gateway_count=$(wc -l < $temp_file)
else
  vpn_gateway_count=1
fi
resource_count=$(count_resources "Cloud VPN Gateways" $vpn_gateway_count)
total_count=$((total_count + resource_count))

if is_service_enabled "compute.googleapis.com"; then
  echo "Fetching Cloud Interconnects..."
  gcloud compute interconnects list --format="table(name, interconnectType, linkType)" > $temp_file
  cat $temp_file
  interconnect_count=$(wc -l < $temp_file)
else
  interconnect_count=1
fi
resource_count=$(count_resources "Cloud Interconnects" $interconnect_count)
total_count=$((total_count + resource_count))

if is_service_enabled "file.googleapis.com"; then
  echo "Fetching Cloud Filestore instances..."
  gcloud filestore instances list --format="table(name, tier, capacityGb, status)" > $temp_file
  cat $temp_file
  filestore_count=$(wc -l < $temp_file)
else
  filestore_count=1
fi
resource_count=$(count_resources "Cloud Filestore instances" $filestore_count)
total_count=$((total_count + resource_count))

# Display counts, ignoring zeros
echo
echo "----------------------"
echo "Summary of Resources:"
echo "Total Resources Count: $total_count"

# Cleanup temp file
rm $temp_file

