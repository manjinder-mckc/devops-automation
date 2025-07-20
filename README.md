# devops-automation

## DevOps Interview – Coding Exercise

During this session, you will be building a simple web server and deploying it into Kubernetes. You will act as the Continuous Integration and Continuous Deployment systems to the extent that you can:

- Run scripts you have written
- Manually pass variables and values between scripts if needed

During the process, please create documentation and tests where appropriate. If you find yourself needing to make compromises due to time constraints or the system that is available, please note them down and explain why they are compromises.

For example:
- Requests are made over `http` because the cluster does not have appropriate ACM certs available.

You will be asked to provide at least two scripts. You may decide you want to write more. Please write one of those scripts in a shell language (bash, sh, etc.) and the other script in a higher-level scripting language (Python, Ruby, JavaScript, etc.).

---

## Prerequisites

- You are able to build Docker images.
- You can create a public Docker repository to which you will push images (note the name can be obfuscated if you would like).
- You will need to be able to create some Git repositories that can be shared.
- `terraform` is installed.
- `git` is installed.
- `kubectl` is installed.

---

## Interview Setup

You will be provided with a `kubeconfig` file that will give you access to a Kubernetes cluster. Please validate that you can communicate successfully with that cluster. If you need other resources to be provided, please let the interviewer know so they can help.

---

## The Application

The application is simple. It is a basic web server that serves three static files:

- `/index.html`
- `/page1.html`
- `/version.json` — this should contain information about the build.

Feel free to create whatever content you would like for this static content. You may use Apache, Nginx, or another web server of your choice. Please install `curl` on this Docker image for testing.

---

### Building the Application

Write a script that:

- Creates a Docker image.
- Publishes that image.
- Outputs an appropriate version that can be used for deployments.

---

### Application Deployment

You will use `terraform` to deploy your application into a Kubernetes cluster and store this in Git. Create the Kubernetes resources that you believe should be deployed for this application to work.

---

### Continuous Delivery

Write a script that:

- Takes the version as input.
- Updates the `terraform` code and creates a PR with the changes.
- When you merge the PR, apply the `terraform`. (Note: This does not have to be part of the above script.)

---

## Deliverables

- Git repository/repositories containing code.
- Application code.
- Terraform configuration.
- One shell script (bash, sh, etc.).
- One script written in a higher-level language (Python, Ruby, Perl, JavaScript, Groovy, etc.).
- PRs associated with changes that have been made.
- Demo of a functioning deployment process from code change to deployment.

---

## Enhancements

Once you have this process working, please work on any of the following enhancement requests. If you can’t make it through all of these, that is fine.

### Enhancement 1

We want to be able to talk to this service from the outside.

- The cluster is set up to support `LoadBalancer` services.
- We do not have the ACM certs available, so just use `http`.

---

### Enhancement 2

As a “developer,” add a redirect to your site:

- Redirect `/page1.html` → `/page-2.html`.
- Update some content in `/page-2`.

Acting as the CI/CD, deploy these changes via your process above.

---

### Enhancement 3

We want to be able to change some properties without needing to rebuild our application. Pick one or both of these options:

- Update a header based on the value of an environment variable.
- Update a page to have content based on the value of an environment variable.

Acting as the CI/CD, deploy these changes via your process above.

---

### Enhancement 4

We want to have an entire page’s content provided via a ConfigMap.

- Please serve `/config.html` from the contents of a ConfigMap.

Acting as the CI/CD, deploy these changes via your process above.

---

### Enhancement 5

Install a benchmarking/load testing tool on one of the instances. `siege` is a straightforward option if you are not familiar with other tools.

- Acting as the CI/CD, deploy these changes via your process above.
- Execute a load test and provide some results.

---

### Enhancement 6

Create a module so you can deploy the application multiple times.