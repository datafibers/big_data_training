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
# Oozie Setup Issues

#### Issues 1. Oozie web console is disabled. 
To enable Oozie web console, we need to install the Ext JS library (in the current directory).
1. Copy it to the path ```cp ext-2.2.zip /usr/hdp/current/oozie-client/libext/```
2. Regenerate the war file by executing ```/usr/hdp/current/oozie-server/bin/oozie-setup.sh prepare-war```
3. Restart Oozie from Ambari

#### Issue 2. Oozie stuck at PRE status
1. In Ambari oozie config, choose **Existing MySQL / MariaDB Database**
1. Database Name: oozie
1. Database Username: root
1. Database Password: hadoop
1. JDBC Driver Class: com.mysql.jdbc.Driver
1. Database URL: jdbc:mysql://sandbox-hdp.hortonworks.com/oozie
1. Oozie Data Dir: /hadoop/oozie/data
1. Restart all oozie servers and choose all suggested changes
