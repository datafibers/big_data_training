# Oozie Demo Setup

## Upload code
```
hdfs dfs -mkdir -p /user/root/
cd big_data_training/oozie
hdfs dfs -put -f examples /user/root/
```

## Setup variable/alias by running below or put it in .bashrc
```
export OOZIE_URL=http://localhost:11000/oozie
alias ozk='oozie job -kill'
alias oza='oozie jobs -localtime -filter status=RUNNING'
alias ozi='oozie job --info'
alias watch='watch '
```

## Command reference
* Submit a job
```
oozie job -config examples/apps/map-reduce/job.properties -run
```
* Check a job status
```
ozi <job_id>
```
* Check all running job 
```
oza <job_id>
```
* Check a job with live update, wwf.sh is in the current folder.
```
./wwf <job_id>
```
* Kill a job
```
ozk <job_id>
```
