#!/bin/bash

# parse branch
if [ -f $GITHUB_EVENT_PATH ]; then
	# in case of push event
	BRANCH=$(cat $GITHUB_EVENT_PATH | jq -r .ref | awk -F '/' '{print $3}')

	if [ -z "$BRANCH" ]
    then
    	# in case of pullresuest event
    	BRANCH=$(cat $GITHUB_EVENT_PATH | jq -r .pull_request.head.ref)
    fi
else
	echo "Required file on path 'GITHUB_EVENT_PATH' not exists"
fi
khulnasoft auth create-context context --api-key $ORG_REO_TOKEN
khulnasoft auth use-context context

if [ -n "$KS_BRANCH" ]
then
  BRANCH=$KS_BRANCH
fi

echo "Execute pipeline with branch $BRANCH"

if [ -n "$TRIGGER_NAME" ]
then
	khulnasoft run $PIPELINE_NAME --trigger=$TRIGGER_NAME --branch=$BRANCH ${@:1}
else
	khulnasoft run $PIPELINE_NAME --branch=$BRANCH ${@:1}
fi
