# Scripts to deploy kubernetes (k3s) cluster
This is a collection of scripts for rapid (and lazy) deployment that I have created to ease my pain with Kubernetes.

Each app/service scripts are located in separate forlders. Each folder has it's own `.env` file that should be checked for appropriate settings. 

Installation script has the same name as parent folder e.g.: `longhorn.sh` inside `longhorn` folder. Uninstallation script is always called `uninstall.sh`

## Installation order

#### Mandatory
Steps below are mandatory. All optional apps will rely on it.
1. `bare-k8s-install` - install kubernetes cluster to master and worker(s). It's a Big Bang.
2. `dashboard` - install kubernetes dashboard to make life easier.
3. `longhorn` - install longhorn distributed filesystem so we can store our data.
4. `traefik` - k3s has traefik preinstalled. We need to enable basic auth support.
5. `cert-manager` - install cert-manager so SSL will not bother us.

#### Optional
Steps below are optional.
1. `portainer` - install alternative dashboard is you like dockers as much as I do.
