# Variable
data=$(date +'%Y-%m-%dT%H%M%S')

# path
path_papermill='/home/ubuntu/.pyenv/shims/'
path_file='/home/ubuntu/Customer-Clusterization'

source /home/ubuntu/.pyenv/versions/pa005insiders/bin/activate

papermill $path_file/clusterizacao_C7_deploy.ipynb $path_file/reports/C7_insiders_report_$data.ipynb
