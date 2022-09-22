# Variable
data=$(date +'%Y-%m-%dT%H%M%S')

# path
path_papermill='/home/ubuntu/.pyenv/shims/'
path_file='/home/ubuntu/Customer-Clusterization'

$path_papermill/papermill $path_file/clusterizacao_C7_deploy.ipynb $path_file/reports/C7_insiders_deploy_$data.ipynb
