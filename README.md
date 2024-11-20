# Khulnasoft pipeline runner GitHub Action  

Khulnasoft is a CI/CD platform that engineers actually love to use. The [Khulnasoft pipeline](https://khulnasoft.com/docs/docs/configure-ci-cd-pipeline/pipelines/) runner GitHub action will trigger an existing Khulnasoft pipeline from a GitHub action.

It is based on the [Khulnasoft CLI](https://khulnasoft.github.io/cli/) which can execute Khulnasoft pipelines remotely (using an API key for authentication). The Khulnasoft CLI is already available as a [public Docker image](https://hub.docker.com/r/khulnasoft/cli/), so creating a GitHub action with it is a trivial process.

## Integrating Khulnasoft pipelines with GitHub actions

GitHub actions are a flexible way to respond to GitHub events and perform one or more tasks
when a specific GitHub event happens. GitHub actions can also use Khulnasoft pipelines as a back-end
resulting in a very powerful combination where the first action starts from GitHub, but Khulnasoft takes care
of the actual compilation or deployment in a pipeline.

## Prerequisites

Make sure that you have

* a GitHub account with Actions enabled
* a [Khulnasoft account](https://khulnasoft.com/docs/docs/getting-started/create-a-khulnasoft-account/) with one or more existing pipelines ready
* a [Khulnasoft API token](https://khulnasoft.com/docs/docs/integrations/khulnasoft-api/#authentication-instructions) that will be used as a secret in the GitHub action


## How the Khulnasoft action works

The GitHub workflow is placed on the [push event](https://developer.github.com/v3/activity/events/types/#pushevent) and therefore starts whenever a Git commit happens. The Workflow has a single action that starts the Khulnasoft pipeline runner.

The pipeline runner is a Docker image with the Khulnasoft CLI. It uses the Khulnasoft API token to authenticate to Khulnasoft and then calls a an existing pipeline via its trigger.

The result is that all the details from the Git push (i.e. the GIT hash) are transferred to the Khulnasoft pipeline that gets triggered remotely

## How to use the Khulnasoft GitHub action

An example of workflow

```
name: run khulnasoft pipeline
on: push
jobs:
  build:
    runs-on: ubuntu-18.04
    steps:
      - name: Checkout
        uses: actions/checkout@master
        
      - name: 'run pipeline'
        uses: khulnasoft/khulnasoft-pipeline-runner@v8
        with:
          args: '-v key1=value1 -v key2=value2'
        env:
          PIPELINE_NAME: 'khulnasoft-pipeline'
          TRIGGER_NAME: 'khulnasoft-trigger'
          ORG_REO_TOKEN: ${{ secrets.ORG_REO_TOKEN }}
        id: run-pipeline
```
### Env variables
* A secret with name `ORG_REO_TOKEN` and value your Khulnasoft API token ( https://khulnasoft.com/docs/docs/integrations/khulnasoft-api/#authentication-instructions )
* An environment variable called `PIPELINE_NAME` with a value of `<project_name>/<pipeline_name>`
* An optional environment variable called `TRIGGER_NAME` with trigger name attached to this pipeline. See the [triggers section](https://khulnasoft.com/docs/docs/configure-ci-cd-pipeline/triggers/) for more information
* An optional environment variable called `KS_BRANCH` with branch name .

Click the Done button to save your changes and commit.

Now next time you commit anything in your GitHub repository the Khulnasoft pipeline will also execute.

### Outputs
The action will report if the pipeline execution was successful. For example, if your pipeline has unit tests that fail, by default, it will report the action failed. The logs from the pipeline will be streamed into the Github action console.

