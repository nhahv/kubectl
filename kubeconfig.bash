# Parse namespace (-n|--namespace) and NAME from arguments
NS="internal"
NAME="gitlab-token"
args=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--namespace)
      NS="$2"
      shift 2
      ;;
    *)
      args+=("$1")
      shift
      ;;
  esac
done
if [[ ${#args[@]} -gt 0 ]]; then
  NAME="${args[-1]}"
fi


TOKEN=$(kubectl get secret $NAME -n $NS -o jsonpath='{.data.token}' | base64 -d)
APISERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}') 
CA=$(kubectl get secret $NAME -n $NS   -o jsonpath='{.data.ca\.crt}')

cat <<EOF > config-${NS}-${NAME}.yaml
apiVersion: v1
kind: Config
clusters:
- name: ${APISERVER}
  cluster:
    server: ${APISERVER}
    certificate-authority-data: ${CA}
users:
- name: ${NAME}
  user:
    token: ${TOKEN}
contexts:
- name: ${NAME}@${APISERVER}
  context:
    cluster: ${APISERVER}
    user: ${NAME}
    namespace: ${NS}
current-context: ${NAME}@${APISERVER}
EOF

echo "Kubeconfig file 'config-${NS}-${NAME}.yaml' created."
cat config-${NS}-${NAME}.yaml
