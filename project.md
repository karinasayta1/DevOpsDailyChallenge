
# EasyShop — Resume and Interview Guide

This guide explains the project in plain English. Read Part 1 until you can tell the story without looking at the file. Then practice Part 2 out loud.

The application is an online shop called **EasyShop**. Your work on it is the DevOps work: packaging the app, building it automatically, and running it on AWS.

---

# Part 1 — Everything you should know

## 1. The 30-second version

EasyShop is a shopping website. Customers can browse products, create an account, add items to a cart, and place an order.

The website and its API are one Next.js application. Product, user, cart, and order data live in MongoDB.

I packaged that application with Docker. Terraform creates the AWS network, an EKS Kubernetes cluster, and a Jenkins server. Jenkins builds the Docker images, runs cart unit tests, scans the images, pushes them to Docker Hub, and updates the Kubernetes files in Git. Argo CD reads those files and deploys the new version onto the cluster. Users reach the site through an Nginx ingress with HTTPS.

## 2. Lines you can put on a resume

Use these only for work you can explain. If the interviewer opens the repository, these names must match what you say.

- Containerized a Next.js and MongoDB e-commerce application with a multi-stage Docker build and Docker Compose.
- Provisioned an AWS VPC, an EKS cluster, and a Jenkins EC2 server with Terraform.
- Built a Jenkins pipeline that builds two images, runs unit tests, scans them with Trivy, pushes them to Docker Hub, and updates the Kubernetes image tag in Git.
- Deployed the shop and MongoDB on Kubernetes with health checks, resource limits, and a CPU autoscaler from 2 to 5 replicas.
- Used Argo CD so the cluster follows Git, and exposed the app with Nginx Ingress and cert-manager HTTPS.

A short project title:

**EasyShop — CI/CD and Kubernetes deployment for an e-commerce application**

Tools to list: Git, Docker, Docker Compose, Jenkins, Trivy, Docker Hub, Terraform, AWS (EC2, VPC, EKS), Kubernetes, Helm, Argo CD, Nginx Ingress, cert-manager.

## 3. What the shop does

A visitor can:

- Open the home page and see banners and categories such as clothes, gadgets, books, and grocery.
- Open a shop, a category, or one product.
- Search and filter by price, color, and category.
- Add a product to the cart or the wishlist.
- Register, log in, and open a profile.
- Check out and look at past orders.
- Switch between light and dark mode.

Main pages:

| Address | What it is |
|---|---|
| `/` | Home page |
| `/shops` | List of shops |
| `/products/...` | One product |
| `/checkout` | Place an order |
| `/login` and `/register` | Account |
| `/profile` | Profile, orders, wishlist |

The same program also serves the API:

| API | What it does |
|---|---|
| `/api/products` | List and read products |
| `/api/cart` | Read and change the cart |
| `/api/orders` | Create and read orders |
| `/api/auth/register`, `/login`, `/logout`, `/me` | Account and login |

## 4. How one click travels through the shop

There are three layers.

**Screen.** React pages and components. Tailwind CSS styles them. Redux remembers the cart and the logged-in user in the browser while the person clicks around.

**Rules.** A Next.js API route receives the request, checks it, and checks the login. Passwords are scrambled with bcrypt before they are saved. After login, the server gives the browser a JWT, which is a signed note that says who the user is. The next request sends that note back.

**Data.** MongoDB stores users, products, carts, and orders. Mongoose describes the shape of each record. A product has a title, price, images, categories, colors, sizes, and stock. A user has a name, email, password, role, and addresses.

Example: the customer opens a product.

1. The page asks `/api/products/...`.
2. The API route asks MongoDB.
3. MongoDB returns the product.
4. The page draws it.

Cart total and discount are calculated in `src/lib/utils.ts`.

- `totalPrice` adds `price × quantity` for every cart item. A missing quantity counts as 1.
- `discountPercent` turns the difference between the old price and the new price into a percent such as `20%`.

## 5. The folders

| Folder or file | What it is |
|---|---|
| `src/app` | Pages and API routes |
| `src/components` | Buttons, cards, forms, navbar |
| `src/lib` | Database, login helpers, cart math, Redux |
| `tests` | Cart unit tests |
| `Dockerfile` | How the shop image is built |
| `scripts/Dockerfile.migration` | How the one-time data-load image is built |
| `docker-compose.yml` | Starts database, data load, and shop on one computer |
| `Jenkinsfile` | The automatic build and release steps |
| `terraform` | AWS network, EKS cluster, and Jenkins server |
| `kubernetes` | What should be running in the cluster |

## 6. How it runs on one computer

`docker-compose.yml` starts three containers, in this order:

1. **MongoDB** on port 27017. A health check waits until the database answers.
2. **Migration.** Loads sample products, then exits.
3. **The shop** on port 3000. It starts only after the migration succeeds.

The shop image is built in two steps (`Dockerfile`):

- Step 1 uses Node 18, installs dependencies, and runs `npm run build`.
- Step 2 keeps only the finished application. The running image is smaller because it does not contain the source files and build tools.

Open `http://localhost:3000` to see the shop.

## 7. What Terraform creates

Terraform files in `terraform/` describe AWS. `terraform plan` shows the change. `terraform apply` creates it.

Region in `provider.tf`: **eu-west-1**.

**Network (VPC).**

- Name: `tws-eks-cluster`
- Address range: `10.0.0.0/16`
- Two zones: `eu-west-1a` and `eu-west-1b`
- Public subnets for internet-facing load balancers
- Private subnets for internal load balancers
- Intra subnets for the Kubernetes control plane
- A NAT gateway so private machines can reach the internet

**EKS cluster** (`terraform/eks.tf`).

- Cluster name: `tws-eks-cluster`
- The API endpoint is public
- Add-ons: CoreDNS, kube-proxy, VPC CNI
- Worker group `tws-demo-ng`
- Machine type: `t2.large`
- Buying option: Spot, which is cheaper and can be interrupted
- Minimum 2 machines, desired 2, maximum 3
- Disk: 35 GB

**Jenkins server** (`terraform/ec2.tf`).

- One Ubuntu EC2 machine
- Name tag: `Jenkins-Automate`
- Type: `t2.medium` (from `variables.tf`)
- Disk: 20 GB
- Open ports: 22 (SSH), 80 (HTTP), 443 (HTTPS), 8080 (Jenkins)
- On first boot, `install_tools.sh` installs Java, Jenkins, Docker, Trivy, AWS CLI, Helm, and kubectl
- Jenkins is added to the Docker group so the pipeline can build images

Jenkins is on its own machine. The shop runs on the EKS workers. If the shop cluster has a problem, Jenkins can still build.

## 8. The Jenkins pipeline, stage by stage

The file is `Jenkinsfile`. Jenkins loads a shared library named `Shared`. Some steps, such as `clone`, `docker_build`, `run_tests`, `trivy_scan`, `docker_push`, and `update_k8s_manifests`, come from that library.

The repository URL in the file is `https://github.com/karinsayta1/e-commerce-app.git`, branch `master`.

The image names in the file are still:

- `trainwithshubham/easyshop-app`
- `trainwithshubham/easyshop-migration`

The tag is the Jenkins build number, such as `12`. A new build never reuses the tag `latest`, so you can see which version is running.

Stages, in order:

1. **Cleanup Workspace.** Deletes old files so this build does not reuse leftovers from the previous build.
2. **Clone Repository.** Downloads the `master` branch.
3. **Build Docker Images.** Builds the shop image and the migration image at the same time.
4. **Run Unit Tests.** Explained in the next section.
5. **Security Scan with Trivy.** Looks for known vulnerable packages in the image.
6. **Push Docker Images.** Uploads both images to Docker Hub, using the credential id `docker-hub-credentials`.
7. **Update Kubernetes Manifests.** Writes the new image tag into the files in `kubernetes/` and commits that change. The Git user recorded in the file is `Jenkins CI` / `shubhamnath5@gmail.com`.

A GitHub webhook can start this pipeline when code is pushed. Building on every change is continuous integration. Updating the running system from that build is continuous delivery.

## 9. The unit-test stage

```groovy
stage('Run Unit Tests') {
    steps {
        script {
            run_tests()
        }
        sh '''
            docker run --rm \
              -v "$PWD":/app \
              -w /app \
              node:18-alpine \
              sh -c "apk add --no-cache python3 make g++ && npm ci && npm test"
        '''
    }
}
```

It does two things.

`run_tests()` is the shared-library step. Its body is not in this repository.

The `sh` step then runs the tests that are in this repository. The Jenkins machine does not need Node.js installed. Docker starts a temporary Node 18 container:

- `-v "$PWD":/app` shows the project folder to the container.
- `apk add` installs compilers that some npm packages need while they install.
- `npm ci` installs the exact dependency versions from the lockfile.
- `npm test` runs `node --test tests/pricing.test.js`.
- `--rm` deletes the container at the end.

`tests/pricing.test.js` checks the real functions in `src/lib/utils.ts`. There are six checks:

- An empty cart totals `0`.
- A missing quantity counts as `1`.
- Two items, `25 × 2` and `40.5 × 1`, total `90.5`.
- Price `80` against old price `100` is `20%` off.
- Prices sent as text, `"50"` and `"200"`, are `75%` off.
- An unchanged price is `0%` off.

If `npm test` fails, the stage fails. Jenkins does not scan, push, or update Kubernetes for that build.

These tests run after the image build in this Jenkinsfile. A stricter pipeline would run them before the image build, so a failing test would not spend time building an image.

## 10. What Kubernetes runs

All of these objects are in the namespace `easyshop`. A namespace is a separate room in the cluster so this app does not mix with other apps.

| File | What it creates |
|---|---|
| `01-namespace.yaml` | The `easyshop` namespace |
| `02` and `03` | A disk and a disk claim for MongoDB |
| `04-configmap.yaml` | Normal settings: database address, site URL, environment |
| `05-secrets.yaml` | Login signing keys. Real secrets should not be committed to a public repository |
| `06-mongodb-service.yaml` | A stable name, `mongodb-service`, for the database |
| `07-mongodb-statefulset.yaml` | One MongoDB pod with the disk mounted at `/data/db` |
| `08-easyshop-deployment.yaml` | Two copies of the shop |
| `09-easyshop-service.yaml` | A stable name for the shop inside the cluster |
| `10-ingress.yaml` | The public door for a domain name |
| `11-hpa.yaml` | Adds shop copies when CPU is high |
| `12-migration-job.yaml` | Loads sample products once, then stops |
| `00-cluster-issuer.yml` | Tells cert-manager which certificate issuer to use |

The shop deployment:

- Image example: `trainwithshubham/easyshop-app:1`. Jenkins replaces `1` with the build number.
- `imagePullPolicy: Always` makes Kubernetes pull that tag again.
- The container listens on port 3000.
- Settings come from the ConfigMap `easyshop-config` and the Secret `easyshop-secrets`.
- Request: 256 MB memory and 200 millicores of CPU. Limit: 512 MB and 500 millicores.
- Startup, readiness, and liveness checks call the home page. Kubernetes sends users to a pod only after it answers. If a pod later stops answering, Kubernetes replaces it.

MongoDB is a StatefulSet, not a normal Deployment. The database must keep the same name and the same disk. A normal Deployment can replace a pod and lose that.

The autoscaler (`easyshop-hpa`) watches the shop deployment. It keeps at least 2 pods and at most 5. If average CPU stays above 70 percent, it adds pods. When traffic falls, it scales back down.

## 11. How users reach the site

Inside the cluster, only other containers can see the shop. The public path is:

Browser → domain name → AWS load balancer → Nginx Ingress → `easyshop-service` → one shop pod → MongoDB.

Nginx Ingress is installed with Helm into the namespace `ingress-nginx`. Its Service type is LoadBalancer, so AWS gives it a public address.

cert-manager, also installed with Helm, asks Let’s Encrypt for a certificate. The ingress file turns on TLS and redirects HTTP to HTTPS. The host written in `kubernetes/10-ingress.yaml` is `easyshop.letsdeployit.com`. For your own site, that host and the DNS record must be yours.

## 12. Argo CD

Argo CD is installed in the namespace `argocd`. It watches the `kubernetes` folder in Git.

Jenkins does not log into the cluster and apply files. Jenkins only changes the image tag in Git. Argo CD sees the new commit and updates the running pods. Git is the record of what should be running. This pattern is called GitOps.

If someone changes the cluster by hand, Argo CD can put it back to what Git says.

## 13. The full path of one code change

1. You change the shop and push to GitHub.
2. GitHub tells Jenkins.
3. Jenkins cleans the workspace and clones `karinsayta1/e-commerce-app`.
4. Jenkins builds the shop image and the migration image.
5. Jenkins runs `run_tests()`, then the six cart tests in Docker.
6. Trivy scans the image.
7. Both images are pushed to Docker Hub with the build number as the tag.
8. Jenkins commits the new tag into the Kubernetes deployment file.
9. Argo CD rolls out new pods.
10. Kubernetes waits until the new pods answer the health check, then removes the old pods.

## 14. Words you must be able to define

| Word | Plain meaning |
|---|---|
| Docker image | The packed application. |
| Container | That package while it is running. |
| Docker Compose | One file that starts several containers together. |
| Multi-stage build | Build in one stage, run from a smaller second stage. |
| CI | Automatically build and test every change. |
| CD | Automatically release a good build. |
| Jenkins shared library | Reusable pipeline steps stored in another repository. |
| Trivy | Scanner for known security problems in images and dependencies. |
| Terraform | Files that create cloud resources. |
| VPC | Your private network in AWS. |
| EC2 | One rented virtual machine. |
| EKS | Kubernetes managed by AWS. |
| Spot instance | A cheaper machine that AWS can take back. |
| Pod | One or more containers Kubernetes runs together. |
| Deployment | Keeps a set number of identical pods running. |
| StatefulSet | Like a Deployment, but the pod keeps a stable name and stable disk. |
| Service | A fixed address in front of changing pods. |
| Ingress | Routes a public hostname to a Service. |
| ConfigMap | Non-secret settings. |
| Secret | Passwords and signing keys. |
| HPA | Adds or removes pods from CPU or memory. |
| Probe | A health check. |
| GitOps | Git is the source of truth, and a tool makes the cluster match Git. |
| Argo CD | The GitOps tool used here. |

## 15. Names in the code that you should know before an interview

Say these exactly if someone reads the files with you.

| What | Name in the code today |
|---|---|
| Shop | EasyShop |
| GitHub repo in the Jenkinsfile | `karinsayta1/e-commerce-app` |
| Kubernetes namespace | `easyshop` |
| EKS cluster | `tws-eks-cluster` in `eu-west-1` |
| Docker images | `trainwithshubham/easyshop-app` and `trainwithshubham/easyshop-migration` |
| Jenkins manifest commit email | `shubhamnath5@gmail.com` |
| Domain in the ingress file | `easyshop.letsdeployit.com` |

Before a real interview, change the Docker Hub names, the Jenkins Git email, and the domain to your own. If you have not changed them yet, say so. Do not claim those accounts are yours.

Also say this clearly: the shopping screens and API came with the application. Your project work is the automation around it: Docker, Terraform, Jenkins, tests, Kubernetes, and Argo CD.

## 16. What you would improve

These are good honest answers if the interviewer asks what is missing.

- Run the unit tests before the Docker build.
- Fail the pipeline when Trivy finds a serious vulnerability.
- Store real secrets in AWS Secrets Manager or a sealed secret, not in Git.
- Use a managed database such as Amazon DocumentDB or MongoDB Atlas instead of one MongoDB pod.
- Add a staging environment before production.
- Point the image names at your own Docker Hub account.

---

# Part 2 — Interview questions and answers

Speak the answers in the first person. Keep them short, then stop. Let the interviewer ask for more.

## A. Project introduction

**1. Tell me about this project.**

I automated deployment for EasyShop, an e-commerce application. The app is Next.js and MongoDB. Customers can browse products, log in, use a cart, and place orders. I containerized it with Docker, created the AWS network, EKS cluster, and Jenkins server with Terraform, and wrote a Jenkins pipeline that tests, scans, and publishes the image. Argo CD deploys the Kubernetes manifests from Git.

**2. What was your role?**

I was the DevOps engineer. I did not build the shopping pages. I made the application build and run the same way every time, from a laptop to AWS.

**3. Why did the business need this?**

A manual deploy is slow and easy to get wrong. The pipeline gives every change the same build, the same tests, and a record of which image tag went to the cluster.

**4. What happens when a developer pushes code?**

GitHub calls Jenkins. Jenkins clones the repo, builds two images, runs the cart unit tests, scans with Trivy, and pushes the images to Docker Hub using the build number as the tag. It then commits that tag into the Kubernetes files. Argo CD sees the commit and rolls out new pods. Kubernetes waits for the health check before it removes the old pods.

## B. The application

**5. What is the application stack?**

Next.js 14 for the pages and the API, React for the screens, Tailwind for styling, Redux for the cart in the browser, MongoDB for data, and Mongoose as the database helper. Login uses bcrypt for passwords and JWT for the session token.

**6. Why is the frontend and backend in one project?**

Next.js serves both. The pages and the routes under `src/app/api` are the same application, so there is one Docker image for the shop.

**7. What data is stored?**

Users, products, carts, and orders. A product has title, price, images, categories, colors, sizes, and stock.

**8. How does login work?**

The user sends an email and password. The API checks the password against the bcrypt hash. If it matches, the API signs a JWT. The browser sends that token on later requests, and the API verifies it.

## C. Docker

**9. Why Docker?**

The app carries its runtime with it. The same image runs on my laptop, on Jenkins, and on Kubernetes. We do not keep a separate list of install steps for each machine.

**10. Why two images?**

One image is the shop, and it stays running. The other is the migration job. It loads sample products and then stops.

**11. What is a multi-stage build?**

The first stage installs tools and builds the Next.js app. The second stage copies only the finished files. The running image is smaller and does not contain the compilers.

**12. What does Docker Compose do?**

It starts MongoDB, waits until it is healthy, runs the migration, and then starts the shop on port 3000. One command brings up the whole local stack.

**13. Why is the image tag the build number instead of `latest`?**

`latest` does not tell you which build is running, and two builds can overwrite it. Build number `12` always means Jenkins build 12.

## D. Jenkins and tests

**14. Walk me through the Jenkinsfile.**

Cleanup, clone, build both images in parallel, run unit tests, Trivy scan, push both images in parallel, then update the Kubernetes manifest in Git.

**15. What does the unit-test stage do?**

It first calls `run_tests()` from the shared library. Then it starts a Node 18 container, installs dependencies with `npm ci`, and runs `npm test`. The test file checks cart total and discount percent. If a test fails, the pipeline stops before the image is pushed.

**16. Why run tests inside Docker?**

The Jenkins EC2 server is installed with Java, Jenkins, Docker, Trivy, AWS CLI, Helm, and kubectl. It does not need a separate Node.js install. The container provides Node 18.

**17. What exactly do the six tests check?**

Empty cart is 0. Missing quantity counts as 1. Price times quantity is summed. An 80 price against a 100 old price is 20 percent off. String prices still work. No price change is 0 percent.

**18. Why is the test stage after the image build?**

That is the order in this Jenkinsfile. I would move the tests before the build so a failing test does not spend time building an image.

**19. What is a Jenkins shared library?**

It is a separate Git repository of reusable pipeline steps. This Jenkinsfile calls `clone`, `docker_build`, `docker_push`, `trivy_scan`, and `update_k8s_manifests` from the library named `Shared`.

**20. How does Jenkins get the code automatically?**

A GitHub webhook sends the push event to Jenkins. The job is set to start on that hook. The script path is `Jenkinsfile`.

**21. Where are Docker Hub and GitHub passwords stored?**

In Jenkins credentials, not in the Jenkinsfile. The pipeline refers to the ids `docker-hub-credentials` and `github-credentials`.

**22. What does Trivy do?**

It scans the image for known vulnerabilities. I would also fail the build when the scan finds a high or critical issue.

## E. Terraform and AWS

**23. Why Terraform?**

The network, the cluster, and the Jenkins server are written in files. I can review the plan, create them again, and avoid clicking through the AWS console from memory.

**24. What did Terraform create?**

A VPC in eu-west-1, an EKS cluster named `tws-eks-cluster`, and one EC2 machine for Jenkins.

**25. What is the difference between the Jenkins EC2 and the EKS nodes?**

The EC2 machine builds and tests. The EKS nodes run the shop and MongoDB. The builder stays up even if the application cluster is unhealthy.

**26. Why is the EKS API public?**

`cluster_endpoint_public_access` is true, so kubectl can reach the cluster API from outside the private network after AWS credentials are configured. A tighter setup would allow only known IP addresses.

**27. Why Spot instances?**

They cost less for this demo cluster. The tradeoff is that AWS can reclaim them. The node group can grow from 2 machines to 3.

**28. What is a bastion or why do you configure kubectl?**

After Terraform finishes, `aws eks update-kubeconfig` writes the cluster address and certificate into the kubeconfig file. kubectl and Argo CD commands then talk to that cluster.

**29. What runs on the Jenkins machine at first boot?**

`install_tools.sh` installs Jenkins, Docker, Trivy, AWS CLI, Helm, and kubectl, and adds the Jenkins user to the Docker group.

## F. Kubernetes

**30. Why Kubernetes?**

One Docker container does not restart itself, scale, or give you a public URL. Kubernetes keeps the desired number of pods running, replaces unhealthy ones, and works with a load balancer and ingress.

**31. What is a namespace?**

The app lives in the namespace `easyshop`. Its pods, services, and secrets are separated from tools such as `argocd` and `ingress-nginx`.

**32. Why a StatefulSet for MongoDB?**

The database needs a stable name and a stable disk. A Deployment is for identical pods that can be replaced freely. The MongoDB StatefulSet mounts a persistent volume at `/data/db`.

**33. What if that one MongoDB pod dies?**

Kubernetes starts it again and reattaches the same disk, so the files remain. There is still only one database pod, so this is not a highly available database. A managed MongoDB service would be safer for production.

**34. What is a Deployment?**

The shop Deployment asks for 2 pods from the same image. If one crashes, Kubernetes starts another. The HPA can change that number between 2 and 5.

**35. What is a Service?**

Pods get new IP addresses when they restart. `easyshop-service` and `mongodb-service` give the other parts of the cluster a name that stays the same.

**36. What is an Ingress?**

It is the rule that says “this hostname goes to this Service.” Nginx Ingress receives the public traffic and forwards it to `easyshop-service` on port 80, which then goes to the container port 3000.

**37. How does HTTPS work?**

cert-manager sees the ingress annotation and the TLS section, requests a certificate from Let’s Encrypt, and stores it in a Kubernetes Secret. Nginx uses that certificate.

**38. What do the probes do?**

They HTTP GET the home page. The startup probe gives the app time to boot. The readiness probe decides when the pod can receive users. The liveness probe restarts a pod that stops answering.

**39. What do the CPU and memory numbers mean?**

The shop requests 200 millicores and 256 MB, and it is limited to 500 millicores and 512 MB. The request helps Kubernetes choose a machine. The limit stops one pod from using the whole node.

**40. How does autoscaling work?**

The Horizontal Pod Autoscaler watches CPU. Above 70 percent average use, it adds pods, up to 5. Below that, it scales back toward 2. The node group can also grow from 2 EC2 workers to 3 if the pods need more machines.

**41. What is the migration Job?**

It runs the migration image once against `mongodb-service`. A Job is for a task that should finish, not stay running.

**42. ConfigMap or Secret?**

The database URL and the public site URL are in a ConfigMap. JWT and NextAuth signing keys are in a Secret. The deployment reads both at startup.

## G. GitOps and release

**43. Why not let Jenkins run `kubectl apply`?**

Then Git and the cluster can disagree, and there is no single history. In this design, Jenkins changes Git. Argo CD is the only thing that changes the cluster.

**44. What is GitOps?**

The Git commit is the desired state. Argo CD continuously compares the cluster with the `kubernetes` folder and applies the difference.

**45. How do you roll back?**

Revert the manifest commit to the previous image tag. Argo CD deploys that older tag. Because tags are build numbers, the old image is still in Docker Hub.

**46. How do you know the new version is healthy?**

The new pods must pass the readiness check before Kubernetes sends them traffic. If they never become ready, the old pods keep serving.

## H. Security and production judgment

**47. Where should secrets live?**

Not in Git. Jenkins credentials belong in the Jenkins credential store. Application secrets belong in a Kubernetes Secret created from a secret manager. The sample files in this repo include secret values, and I would remove those before a public production repository.

**48. Which ports are open on Jenkins, and is that safe?**

SSH 22, HTTP 80, HTTPS 443, and Jenkins 8080 are open to the world in this Terraform file. For a real system I would restrict SSH and Jenkins to my IP, or put Jenkins behind a VPN.

**49. What is the biggest production risk?**

MongoDB is a single pod. If the disk or the node fails badly, the shop data is at risk. I would move it to a managed database and take backups.

**50. Did you write the React shop?**

No. I took the EasyShop application and automated how it is built, tested, scanned, and deployed. I added the cart unit tests that the pipeline runs.

## I. If they go deeper

**51. What is the difference between a pod and a container?**

A container is the running Docker image. A pod is the Kubernetes wrapper around one or more containers. This shop pod has one container.

**52. What is a replica?**

One copy of the pod. The deployment starts at 2 replicas.

**53. What does `imagePullPolicy: Always` do?**

Kubernetes pulls the image from Docker Hub even if a machine already has a copy of that tag. That matters when a tag is reused. Build-number tags already change every release.

**54. Why Helm?**

Helm installs Nginx Ingress and cert-manager from public charts. I do not write those controllers myself. The shop itself is plain Kubernetes YAML, not a Helm chart.

**55. What would you add next?**

Tests before the image build, a failing gate on serious Trivy findings, my own Docker Hub image names, a staging cluster, managed MongoDB, and secrets kept out of Git.
