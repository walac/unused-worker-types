#!/usr/bin/env python

import taskcluster
import os

def get_worker_types(client_id, access_token):
    provisioner = taskcluster.AwsProvisioner({
        'clientId': client_id,
        'accessToken': access_token
    })

    return map(lambda worker_type: worker_type['workerType'], provisioner.listWorkerTypeSummaries())

worker_types = get_worker_types(
    os.getenv('TASKCLUSTER_CLIENT_ID'),
    os.getenv('TASKCLUSTER_ACCESS_TOKEN')

)

print ' '.join(worker_types)
