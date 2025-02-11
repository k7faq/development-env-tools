export PATH="${PATH}:${HOME}/.docker/bin"
listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}

# lima/nerdctl support 
#alias docker='lima nerdctl'
#alias docker-start='limactl start'
#alias docker-stop='limactl stop'

# Convert Base36 to Decimal - Azure VMSS uses base36 for instance IDs
alias base36="echo $((36#$1))"

python=/usr/local/bin/python3

# runs ansible playbooks using a docker container that is configured with the correct python and ansible versions in a script called run
# alias ansible_playbook="/Users/stevenrhodes/Documents/Projects/docker-containers/ansible_2.7/run"
# alias c7n="custodian run --output-dir=/tmp "

export EDITOR=vim

# File search functions
function f() { find . -iname "*$1*" ${@:2} }
function r() { grep "$1" ${@:2} -R . }

# Create a folder and move into it in one command
function mkcd() { mkdir -p "$@" && cd "$_"; }

function run_in_container {
  ${HOME}/projects/diag-useful-scripts/azure-tf-dev-container/run.sh
}

alias k="kubectl"
alias kga="kubectl get all --all-namespaces"
alias kgp="kubectl get pods"
alias kdp="kubectl describe pod"
alias kdelp="kubectl delete pod"
alias kgd="kubectl get deployments"
alias kdd="kubectl describe deployment"
alias kdeld="kubectl delete deployment"
alias kgn="kubectl get nodes"
alias kgnp="kubectl get nodes -o=custom-columns=NAME:.metadata.name,PROVISIONER:.spec.providerID" 
alias kgns="kubectl get nodes -o=custom-columns=NAME:.metadata.name,STATUS:.status.conditions[-1:].type,VERSION:.status.nodeInfo.kubeletVersion"
alias ktop="kubectl top pods"
alias ktopn="kubectl top nodes"
alias kgcm="kubectl get configmap"
alias kgs="kubectl get secrets"
alias kgsvc="kubectl get svc"
alias kgssc="kubectl get svc --sort-by=.spec.type" # sorts services by type
alias kds="kubectl describe svc"
alias kdsc="kubectl describe configmap"
alias kdssec="kubectl describe secret"
alias kdel="kubectl delete"
alias kdelcm="kubectl delete configmap"	
alias kdels="kubectl delete secret"
alias kdelpvc="kubectl delete pvc"
alias kdelrs="kubectl delete rs"
alias kdelsts="kubectl delete sts"
alias kgv="kubectl get events --sort-by=.metadata.creationTimestamp"
alias kgaas="kubectl get all --all-namespaces"
alias kgpwide="kubectl get pods -o wide"
alias kgpv="kubectl get pods -o=custom-columns=NAME:.metadata.name,CPU:.spec.containers[*].resources.requests.cpu,MEMORY:.spec.containers[*].resources.requests.memory,IMAGES:.spec.containers[*].image --sort-by=.spec.containers[*].resources.requests.cpu"

kubectl () {
    command kubectl $*
    if [[ -z $KUBECTL_COMPLETE ]]
    then
        source <(command kubectl completion zsh)
        KUBECTL_COMPLETE=1 
    fi
}

alias tfi="terraform init"
alias tfp="terraform fmt; terraform plan"
alias tfs="terraform show"
alias tfa="terraform apply"
alias tfd="terraform destroy"
alias tfaa="terraform apply -auto-approve"
alias tfda="terraform destroy -auto-approve"
alias tfdebugen="export TF_LOG=DEBUG; export TF_LOG_PATH=."
alias tfdebugoff="export TF_LOG=; export TF_LOG_PATH="
alias tfclean="rm -rf .terraform terraform.tfstate*"

#######
# Azure Kubernetes Service
######
function aksgc() {
	if [ -z $1 ] || [ -z $2 ];
	then
		aksls table
		echo "
  Usage:
	aksgc < Cluster Name > < Resource Group Name >
		"
	fi

  az aks get-credentials --name $1 --resource-group $2
}

function aksls() {
  if [ -z $1 ];
  then
  	fmt=table
  	echo "
  	aksls table | yaml[c] | json[c] 
  	"
  else
        fmt=$1
  fi
  az aks list --output $fmt
}

function azshow() {
  az account show --output yaml
}

# Qhickly set the Azure subscription using a short code
function azset() {
	case $1 in
		a-dev) S="ProjectA-Dev";;
		a-stg) S="ProjectA-Stag";;
		a-prd) S="ProjectA-Prod";;
		*) 
		echo "
		$1​ is not a valid subscription
		Please use the following format
		< Abbreviation >-< Environment >
		Example: a-dev 

		Environments: dev, stg, prd

		Abbreviation: a, this, that, it, other
	esac

	export SUBSCRIPTION="MySubscription-${S}"
	az account set -s $SUBSCRIPTION --verbose
	echo -e "Subscription set to \e[30;48;5;82m${SUBSCRIPTION}\e[0m"
}
[[ /usr/local/bin/kubectl ]] && source <(kubectl completion zsh)

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# AWS CLI auto completion
complete -C '/usr/local/bin/aws_completer' aws
complete aws 'p/*/`aws_completer`/'

# Azure CLI auto completion
source /usr/local/etc/bash_completion.d/az

# https://krew.sigs.k8s.io/  Plugins for kubectl
export PATH="${PATH}:${HOME}/.krew/bin"

export PATH="$HOME/.tfenv/bin:$PATH" # tfenv supports switching terraform versions

source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

PROMPT='%{$fg[yellow]%}[%D{%a %H:%M:%S}] '$PROMPT
